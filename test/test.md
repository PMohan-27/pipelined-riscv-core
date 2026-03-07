# Running Tests

Tests are written using [cocotb](https://www.cocotb.org/).

## Dependencies

```bash
pip install -r requirements.txt
```

## Test Structure

```text
test/
├── alu_test/        - ALU unit tests
└── toplevel_test/   - Top level integration tests
```

### ALU Tests

```bash
cd test/alu_test
make
```

### Top Level Tests

You can edit [test.s](toplevel_test/assembly/test.s)  and run `bash mem.sh` to run RV32I assembly on the cpu.
Then run:

```bash
cd test/toplevel_test
make
```

