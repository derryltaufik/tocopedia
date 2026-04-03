const { faker } = require("@faker-js/faker/locale/id_ID");

class random {
  static int(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  static poisson(lambda = 1) {
    var L = Math.exp(-lambda);
    var k = 0;
    var p = 1;

    do {
      k++;
      p *= Math.random();
    } while (p > L);

    return k - 1;
  }

  static #poissonVal(min, max, lambda) {
    let poissonValues = [];

    for (let i = min; i <= max; i++) {
      let poissonValue =
        (Math.exp(-lambda) * Math.pow(lambda, i)) / this.#factorial(i);
      poissonValues.push(poissonValue);
    }

    return poissonValues;
  }

  static #factorial(num) {
    let result = 1;

    for (let i = 2; i <= num; i++) {
      result *= i;
    }

    return result;
  }

  static rangedPoisson(min, max, lambda) {
    let poissonValues = this.#poissonVal(min, max, lambda);

    let cumulativeValues = [];
    let cumulativeValue = 0;

    for (let i = 0; i < poissonValues.length; i++) {
      cumulativeValue += poissonValues[i];
      cumulativeValues.push(cumulativeValue);
    }

    let randomNumber = Math.random();

    for (let i = 0; i < cumulativeValues.length; i++) {
      if (randomNumber < cumulativeValues[i]) {
        return i + min;
      }
    }

    return max;
  }

  static binomial(n, p) {
    var x = 0;
    for (var i = 0; i < n; i++) {
      if (Math.random() < p) {
        x++;
      }
    }
    return x;
  }

  static consecutiveDate(count, days_range = 30) {
    const dates = [];
    for (let index = 0; index < count; index++) {
      const date =
        index == 0
          ? faker.date.recent(7, Date.now())
          : faker.date.recent(days_range, dates[index - 1]);
      dates.push(date);
    }
    return dates.reverse();
  }
}
module.exports = random;
