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

```bash
cd test/toplevel_test
make
```
