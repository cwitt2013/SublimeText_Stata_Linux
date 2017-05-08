# SublimeText_Stata_Linux
How to get Sublime Text 3 to interact with Stata on Linux Systems.

So far I'm not aware of any other working solution. If you know one, please let me know!
This is my first version (08 May 2017) and still work in progress. I will give you some guidelines how to get Sublime Text and Stata to interact with each other on a basic level.

1.) You will need to install Sublime Text.

2.) You will need the following Linux packages: wmctrl, xdotool, xclip, xautomation

3.) Install the Package Stata Enhanced (https://packagecontrol.io/packages/Stata%20Enhanced).

4.) You should place a symbolic link of your stata executives (e.g. /usr/local/stata14/xstata-se) in '/usr/local/bin'.

5.) Download the file 'sublime-stata.sh' and place it anywhere you want. My recommendation is to place it into '~/.config/sublime-text-3/Packages/SublimeStataEnhanced'. 

In what follow the path to this file is called DIR.

Edit the file 'sublime-stata.sh' if necessary to choose your version of Stata (to do this you will have to replace the code on line 13 and 16).

6.) Edit Stata.sublime-build ('.config/sublime-text-3/Packages/SublimeStataEnhanced') and replace the content with

```{ "cmd": ["sh DIR/sublime-stata.sh $file"], "file_regex": "^(...*?):([0-9]*):?([0-9]*)", "selector": "source.stata", "shell": true, }
```

If everything is working correctly you should be able to run complete 'do-files' using the shortcut "Ctrl + b".

7.) Now you will need to edit the file 'text_2_stata.py'. Paste the following code into the function 'text_2_stataCommand' after ``switch_focus = ""``:

```
if sublime.platform() == "linux":
    # Get the path to the current file
    filename = self.view.file_name()
    filepath = os.path.dirname(filename)

    # Write the selection to a temporary file in the current directory
    dofile_path = os.path.join(filepath, 'sublime2stata.do')
    this_file = open(dofile_path, 'w')
    this_file.write(all_text)
    this_file.close()

    # Get ST version for returning focus to ST
    if int(sublime.version()) > 3000:
        st_name = "Sublime Text"
    else:
        st_name = "Sublime Text 2"

    cmd = "sh DIR/sublime-stata.sh" + " " + '"' + dofile_path + '"'
    os.system(cmd)
    os.remove(dofile_path)
```
8.) Edit your key bindings in Sublime Text and add the following between the brackets:

```
{ "keys": ["ctrl+d"],
  "command":"text_2_stata",
  "context": [
  {"key": "selector", "operator": "equal", "operand": "source.stata"},]
  },
```

Now you should be able to run the selected code with "Ctrl + D". The current line will be send if no code is selected.


I hope this works... Please let me know if you have any questions or recommendations for improvement.


