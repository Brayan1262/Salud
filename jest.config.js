export default {
  testEnvironment: 'node',
  transform: {},
  testEnvironmentOptions: {},
  projects: [
    {
      displayName: 'backend',
      testMatch: ['<rootDir>/tests-unit/**/*.node.test.js'],
      testEnvironment: 'node',
    },
    {
      displayName: 'frontend',
      testMatch: ['<rootDir>/tests-unit/**/*.js'],
      testEnvironment: 'jsdom',
    },
  ],
};
