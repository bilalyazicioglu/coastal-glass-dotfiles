"""Check lock ownership and metadata cleanup without opening any lock screen."""
from pathlib import Path
import fcntl
import os
import runpy
import subprocess
import tempfile
import types
import unittest
from unittest.mock import patch

SCRIPT=Path(__file__).resolve().parents[1]/'bin/coastal-lock'

class LockTests(unittest.TestCase):
    def setUp(self):
        self.module=runpy.run_path(str(SCRIPT))
        self.main=self.module['main']
        self.env=self.main.__globals__
        self.temp=tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.hints=[]
        self.env['locked_hint']=lambda path,locked:self.hints.append((path,locked))
        self.env['session_path']=lambda:'/session/current'
        self.env['run']=lambda args:types.SimpleNamespace(returncode=1)

    def invoke(self,code=0):
        with patch.dict(os.environ,{'XDG_RUNTIME_DIR':self.temp.name}):
            with patch.object(subprocess,'run',return_value=types.SimpleNamespace(returncode=code)) as lock:
                result=self.main()
        return result,lock

    def test_authenticated_exit_clears_hint(self):
        result,lock=self.invoke()
        self.assertEqual(result,0)
        lock.assert_called_once_with(['/usr/bin/hyprlock','--immediate-render'])
        self.assertEqual(self.hints,[('/session/current',True),('/session/current',False)])

    def test_locker_failure_never_reports_unlocked(self):
        result,_=self.invoke(1)
        self.assertEqual(result,1)
        self.assertEqual(self.hints,[('/session/current',True)])

    def test_logind_timeout_does_not_prevent_lock(self):
        def broken():raise subprocess.TimeoutExpired('loginctl',10)
        self.env['session_path']=broken
        result,lock=self.invoke()
        self.assertEqual(result,0)
        lock.assert_called_once()
        self.assertEqual(self.hints,[(None,True),(None,False)])

    def test_existing_manual_locker_is_not_duplicated(self):
        self.env['run']=lambda args:types.SimpleNamespace(returncode=0)
        result,lock=self.invoke()
        self.assertEqual(result,0)
        lock.assert_not_called()
        self.assertEqual(self.hints,[])

    def test_concurrent_lock_request_is_not_duplicated(self):
        with (Path(self.temp.name)/'coastal-lock.lock').open('a') as guard:
            fcntl.flock(guard,fcntl.LOCK_EX|fcntl.LOCK_NB)
            result,lock=self.invoke()
        self.assertEqual(result,0)
        lock.assert_not_called()
        self.assertEqual(self.hints,[])

    def test_current_display_session_overrides_stale_environment(self):
        calls=[]
        def fake(args):
            calls.append(args)
            out={'/usr/bin/loginctl':('42\n' if 'show-user' in args else str(os.getuid())+'\n'),
                 '/usr/bin/busctl':'o "/org/freedesktop/login1/session/_342"\n'}
            return types.SimpleNamespace(returncode=0,stdout=out[args[0]])
        self.env['run']=fake
        with patch.dict(os.environ,{'XDG_SESSION_ID':'old'}):
            path=self.module['session_path']()
        self.assertEqual(path,'/org/freedesktop/login1/session/_342')
        self.assertEqual(calls[1][2],'42')
        self.assertEqual(calls[-1][-1],'42')

if __name__=='__main__':unittest.main()
