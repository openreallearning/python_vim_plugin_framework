" myplugin.vim

let current_dir = expand('<sfile>:p:h/')

if !exists('g:include_path')
  let g:include_path = resolve(current_dir . '/' . '../include')
endif

if !exists('g:src_path')
  let g:src_path = resolve(current_dir . '/' . '../src')
endif

let $PYTHONPATH = expand("%:p:h") . ":" . $PYTHONPATH

python3 << EOF
import vim
EOF

function! CallPythonFunction(command_name, module_name, ...)
  python3 << EOF
# Get the function name and arguments from Vim script
args = vim.eval('a:000')

python_args = [*args][0].split(" ")
function_name = python_args[0]
args = python_args[1:]

# Import the module containing the function
module = __import__(module_name)

# Get a reference to the function
function = getattr(module, function_name)

result = function(*args)

# Print the output in a new window
if result != None:
  vim.command("split .{}.output | normal Go{}".format(module_name, result))

EOF

endfunction

function! CreatePythonCommands()

python3 << EOF

import sys
sys.path.append(vim.eval('g:src_path'))
sys.path.append(vim.eval('g:include_path'))

import os
import importlib.util

# Get the Python directory from Vim script
python_dir = vim.eval('g:include_path')

# Find all Python modules in the directory
modules = [f for f in os.listdir(python_dir) if f.endswith('.py') and not f.startswith('__')]
module_names = [os.path.splitext(f)[0] for f in modules]

# Create a Vim command for each function in each module
for module_name in module_names:
    spec = importlib.util.spec_from_file_location(module_name, os.path.join(python_dir, module_name + '.py'))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    functions = [f for f in dir(module) if callable(getattr(module, f))]
    suggestions = str(functions)

    command_name = module_name.capitalize()

    vim.command(f"""
    function! Complete{command_name}(ArgLead, CmdLine, CursorPos) abort
      let cmd_parts = split(a:CmdLine)
      if len(cmd_parts) == 1
        return {suggestions}
      else
        return []
      endif
    endfunction
    """)

    command_string = 'call CallPythonFunction("' + command_name + '", "' + module_name + '", <q-args>)'
    command = 'command! -nargs=* -complete=customlist,Complete' + command_name + ' ' + command_name + ' :execute \'' + command_string + '\''
    vim.command(command)
EOF
endfunction


" Create Vim commands for the functions in the modules
call CreatePythonCommands()
