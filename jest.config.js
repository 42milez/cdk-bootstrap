module.exports = {
  roots: ['<rootDir>/test'],
  testMatch: ['**/test/jest/**/*.test.ts'],
  transform: {
    '^.+\\.tsx?$': 'ts-jest'
  }
};
