contract;

abi MyContract {
    fn test_function() -> u8;
}

impl MyContract for Contract {
    fn test_function() -> u8 {
        42
    }
}
