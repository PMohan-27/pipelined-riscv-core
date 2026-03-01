# Run the test
source ../venv/bin/activate
make -B

gtkwave dump.fst

cd ../..

deactivate