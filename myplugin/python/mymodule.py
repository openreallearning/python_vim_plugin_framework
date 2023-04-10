import vim

def foo():
    vim.command("normal! i>>  ")
    vim.command("normal! iHello!")
    return "Hello World!\n\n"

def bar(x, y):
    return str(int(x) + int(y))

def none():
    print('ok')
    return None

def nothing():
    print('ok')
