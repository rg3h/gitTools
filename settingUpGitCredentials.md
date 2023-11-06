<h2><b>Setting Up a GitHub .git-credentials File</b></h2>
  Instead of manually entering your password for every
  HTTPS GitHub operation, you can store the token in a file that git can read. For more information, see
  <a href="https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git">
    Caching your GitHub credentials in Git</a>
  <br>
  <br>
  <details>
    <summary><b>Create a classic Personal Access Token on GitHub</b></summary>
    <br>
    <ol>
      <li>click on <b>your personal icon</b> located at the top, far right</li>
      <li>click on <b>Settings</b> from the slide-out menu</li>
      <li>scroll down and click on <b>Developer settings</b></li>
      <li>click on <b>Personal access tokens</b> and then <b>Tokens (classic)</b></li>
      <li>click on the <b>Generate new token</b> button and then select <b>Generate new token (classic)</b></li>
      <li>enter a <b>note</b> like "token for home computer"</li>
      <li>I set the expiration to <b>never</b></li>
      <li>click on the <b>repo checkbox</b> (I also clicked on other things like user, delete_repo, etc)</li>
      <li>at the bottom, click on the green <b>Generate token</b> button</li>
      <li>It will show your token; copy it somewhere safe temporarily<br>
      &nbsp;&nbsp;&nbsp;it looks something like: ghp_ioaBgKGPyOplNXTT5tX849ll128uXh020Vl0<br></li>
    </ol>
  </details>

  <details>
    <summary><b>Set up your Local Git for Credentials</b></summary>
    <br>
    <ol>
      <li>on your computer, type this command: &nbsp; <b>git config --global credential.helper store</b></li>
      <li>in an existing repo, do a git command like: <b>git pull</b></li>
      <li>this should ask for your userid and password. For the password, enter the token you saved earlier</li>
      <li>this git action should implicitly create the file <b>$HOME/.git-credentials</b><br>
      The file looks like this:<br>
      <br>
      <table><tr><td>https://USERID:ghp_ioaBgKGPyOplNXTT5tX849ll128uXh020Vl0@github.com</td></tr></table>
      </li>
      <li>now you can delete the temporarily saved token from step 10 above</li>
    </ol>
  </details>
  <br>
  <br>
  <details>
    <summary>In case this is useful: my git-config set up commands</summary>
    <br>
    <sub>
    git config --global user.name "<b>USERID</b>"<br>
    git config --global user.email "<b>YOUREMAIL</b>"<br>
    git config --global color.ui auto<br>
    git config --global core.editor <b>YOUREDITOR</b> (e.g. /usr/bin/emacs)<br>
    git config --global core.excludesfile /home/<b>USERID</b>/.gitignore<br>
    git config --global push.default simple<br>
    git config --global --list<br>
    <b>git config --global credential.helper store</b><br>
    git config --global init.defaultBranch main<br>
    git config --global branch.autosetupmerge true<br>
    git config --global --list<br>
    git config -l --show-origin<br>
    </sub>
  </details>
