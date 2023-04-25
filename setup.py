from setuptools import setup

setup(
    name='vim-python-framework',
    version='0.1.0',
    description='A framework to easily create Vim plugins using Python',
    author='Your Name',
    author_email='your.email@example.com',
    packages=['vim_python_framework'],
    install_requires=[],
    entry_points={
        'console_scripts': [
            'create-vim-python-plugin=create_plugin:main',
        ],
    },
)
