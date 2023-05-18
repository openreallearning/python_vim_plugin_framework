pip install setuptools wheel twine
rm -rf dist build
python setup.py sdist bdist_wheel
twine check dist/*
twine upload dist/*
