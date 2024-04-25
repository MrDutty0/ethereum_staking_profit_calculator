## Usage

- Input data can be changed in the `constants.rb` file.
- Execute the code by running the following command in the terminal:
    ```bash
    ruby main.rb
    ```
- To enable entering input using CLI (Task 2), change the following line in `main.rb` file:

    ```ruby
    staking_calculator = StakingCalculator.create
    ```

    into:

    ```ruby
    staking_calculator = StakingCalculator.create(inputting_data: true)
    ```
    and execute the code once again

## Additional Resources

- [Actual/365 day count convention](https://www.adventuresincre.com/lenders-calcs/)
