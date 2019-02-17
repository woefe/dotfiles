from ranger.api.commands import Command

class fzf_fd_cd(Command):
    """
    :fzf_fd_cd

    Change to any subdirectory of your home directory with fzf.
    The directory list is generated with fd.
    """
    def execute(self):
        import subprocess
        import os.path
        command = "fd  --type d --hidden --exclude .git . $HOME | fzf"

        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
