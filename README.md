<img src="./assets/images/screenshots/gtListScreenshot.png" width="250" align="right" valign="top"/>
<img src="./assets/images/logo/logoText.png" alt="git tools" valign="top"/>
<b>easy-to-use shell scripts for GitHub</b><br>
<sub><sup>version 1.2.2 for Linux | Windows | Apple</sup></sub><br>
<!-- <sup><sub><a href="https://rg3h.github.io/gitTools">https://rg3h.github.io/gitTools</a></sub></sup><br> -->
<br>
<b><i>Easily create, list, or delete repos from the command line</i></b><br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sup>$> gt add shinyNewRepo</sup>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sup>$> gt ls</sup>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sup>$> gt del oldRepo</sup>
<br>
<br>
<a href="https://github.com/rg3h/gitTools/raw/main/gt.zip">
  <img src="./assets/images/downloadButton.png" alt="download the scripts!" valign="middle"/></a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://github.com/rg3h/gitTools/raw/main/gtForApple.zip">
  <img src="./assets/images/downloadForAppleButton.png" alt="download the scripts for Apple!" valign="middle"/></a>
<br>
<br>

<!--
<table><tr><td>
  <sup>
  <b>testing:</b> For Apple, does the first download button work if you use "./gtz.sh" instead of "./gt/sh"
  </sup>
</td></tr></table>
-->

<details>
  <summary><b>Setting Up the Scripts</b></summary>
  <br>
  <ul>
    <li><i><a href="./settingUpGitCredentials.md">set up GitHub credentials if you don't have a home/USERID/.git-credentials file</a></i></li>
    <br>
    <li><details>
      <summary><i>set up for <b>Linux</b></i></summary>
      <ul>
        <li>sudo apt install curl</li>
        <li>unzip gt into (for example): /home/USERID/bin/gt/</li>
        <li>set your $PATH to include /home/USERID/bin/gt</li>
        <li>chmod u+rwx /home/USERID/bin/gt/gt.sh</li>
        <li>(.bashrc) alias gt='/home/USERID/bin/gt/gt.sh'</li>
        <li>test it by typing: <b>gt</b>
      </ul>
    </details></li>
    <li><details>
      <summary><i>set up for <b>Windows</b></i></summary>
      <ul>
        <li>download and install <b><a href="https://www.cygwin.com/">cygwin</a></b></li>
        <li>add C:\cygwin64\bin to your %PATH%</li>
        <li>unzip gt into (for example): C:\USERID\bin\gt\</li>
        <li>set your %PATH% environment variable to include the gt directory</li>
        <li>test it by typing: <b>gt</b>
      </ul>
    </details></li>
  </ul>
  <br>
</details>

<details>
  <summary><b>Running the Scripts</b></summary>
  <br>
  The scripts use code that works for both bash and zsh (Apple uses zsh).<br>
  There is a main script called gt.sh that then calls sub-scripts for each command.<br>
  <br>
  You can do things like:<br>
  <ul>
    <li><code>gt add repoName --public</code> (create a public repo and local directory connected to it)</li>
    <li><code>gt ls -sc</code>  (show a list of repos, sorted by creation date)</li>
    <li><code>gt rm oldRepo</code> (delete a repo on GitHub but leave the local directory intact)</li>
    <li><code>gt help</code></li>
    <li><code>bash /home/bin/gt/gt.sh ls</code> (run it explicitly with bash or zsh)</li>
  </ul>

</details>

<details>
  <summary><b>Potential Future Work</b></summary>
  <br>
  Here is a short list of potential features and commands for <b>gt</b>. Let me know if you have thoughts or want to contribute.
  <br><br>
  <table valign="top">
    <tr><td valign="top"><sup><b>list -details</b></sup></td> <td><sup>a way to pick details or columns to show</sup></td></tr>
    <tr><td valign="top"><sup><b>-q</b></sup></td> <td><sup>quiet mode so that the scripts can pipe or be part of another script</sup></td></tr>
    <tr><td valign="top"><sup><b>add --noLocal</b></sup></td> <td><sup>add a new repository, but don't create a new local dir</sup></td></tr>
    <tr><td valign="top"><sup><b>stats</b></sup></td> <td><sup>create a view that shows stats for one or all repos, the user, etc</sup></td></tr>
    <tr><td valign="top"><sup><b>acp</b></sup></td> <td><sup>a command that takes a file, adds it, commits it, and pushes it</sup></td></tr>
    <tr><td valign="top"><sup><b>undo</b></sup></td> <td><sup>undo for staged, committed, pushed files</sup></td></tr>
    <tr><td valign="top"><sup><b>history</b></sup></td> <td><sup>tracking local repos, locally logging stats like git use-frequency</sup></td></tr>
    <tr><td valign="top"><sup><b>more authentication support</b></sup></td> <td><sup>GitHub supports multiple authentication mechanisms</sup></td></tr>
    <tr><td valign="top"><sup><b>snapshot</b></sup></td> <td><sup>grab/clone a repo, compress, and store it in a well-established location</sup></td></tr>
    <tr><td valign="top"><sup><b>non-bash version</b></sup></td> <td><sup>investigate octokit.js and a more expansive coding environment</sup></td></tr>
    <tr><td valign="top"><sup><b>search</b></sup></td> <td><sup>I have ideas on a more general search/copilot tool</sup></td></tr>
    <tr><td valign="top"><sup><b>Beyond GitHub: what are we really trying to do?</b></sup></td>
      <td><sup>write up on a more general system that addresses first principles of what we are trying to do (continuum of collaboration, publishing, sharing, backup, learning, etc).</sup></td></tr>
  </table>
  <br>
</details>

<details>
  <summary><b>Why Use gitTools?</b></summary>
  <br>
  Creating a new project should be easy. GitTools are simple shell scripts.
  A lot of commercial services, while powerful, are complicated and sometimes pricey.
  You will be relying on how these services:
  <br>
  <br>
  <ul>
    <li>access your code and company information (from userids to data use patterns)</li>
    <li>manage application updates and fix bugs</li>
    <li>address security leaks</li>
    <li>introduce new features and remove old ones</li>
    <li>mischeviously create product lock-in</li>
    <li>help you with a contingency plan should they change privacy policies</li>
  </ul>
  <br>
  That said, git is complicated. Tools to simplify the process will
  reduce development friction and promote better programming practices.
  I do a lot of collaborative prototyping, so being able to spin up a repo in a single command shifts the cognitive load. And believe me, I can use that.
  <br><br>
  <b>gitTool Benefits</b><br>
  <table>
    <tr><td><sup>easy-to-use</sup></td></tr>
    <tr><td><sup>customizable</sup></td></tr>
    <tr><td><sup>transparent (you can read the scripts)</sup></td></tr>
    <tr><td><sup>ubiquitous (same code runs on lots of platforms)</sup></td></tr>
    <tr><td><sup>maintainable (written in modules)</sup></td></tr>
    <tr><td><sup>open source (liberal MIT licensing)</sup></td></tr>
  </table>
  <br>
  <b>Installation, Development, and Maintenance Benefits</b><br>
  <table>
    <tr><td><sup>easy to install</sup></td></tr>
    <tr><td><sup>no opaque exe files to maintain</sup></td></tr>
    <tr><td><sup>works in Windows too </sup></td></tr>
    <tr><td><sup>each command is a separate script</sup></td></tr>
    <tr><td><sup>modular architecture so creating new commands is easier</sup>
    </td></tr>
  </table>
</details>

<details>
  <summary><b>Related Links</b></summary>
  <br>
  <table>
    <tr><td width="400"><sub>
      <a href="https://github.com/git-guides/install-git">Installing Git</a><br>
      <a href="https://docs.github.com/">GitHub Documentation</a><br>
       <a href="https://www.gnu.org/software/bash/manual/bash.html">Bash Reference Manual
</a><br>
      <a href="https://www.redhat.com/sysadmin/learn-bash-scripting">13 resources for learning to write better Bash code</a><br>
      <br>
      <a href="https://docs.github.com/en/rest/repos/repos">GitHub REST API for Repos</a><br>
      <a href="https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic">Classic Personal Access Token</a><br>
      <a href="https://docs.github.com/en/rest/overview/authenticating-to-the-rest-api?apiVersion=2022-11-28">GitHub: Authenticating for the REST API</a><br>
      <a href="https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-authentication-to-github">Github: Authenticating in General</a><br>
      <br>
      <a href="https://docs.github.com/en/github-cli">GitHub CLI</a><br>
      <a href="https://docs.github.com/en/desktop">GitHub Desktop</a><br>
      <br>
      <a href="https://docs.github.com/en/rest/guides/scripting-with-the-rest-api-and-javascript?apiVersion=2022-11-28">
        Scripting with the REST API and JavaScript</a>
      <br>
      <a href="./settingUpGitCredentials.md">setting up GitHub credentials</a><br>
      <a href="https://rg3h.github.io/whichShell">whichShell</a><br>
      <a href="https://rg3h.github.io/gitTools">gitTools</a><br>
      <br>
    </sub></td></tr>
  </table>
</details>
<sub>A <b>shout out</b> to Amit, Kim, and Julio for help on <b>gt</b> and on
broader concepts around computer technology, people, and innovation.
<br>
<a href="https://rg3h.github.io/gitTools/">link to html of this page</a>
<br>
</sub>
