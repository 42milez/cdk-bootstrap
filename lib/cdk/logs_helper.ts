import {RetentionDays} from '@aws-cdk/aws-logs';

export function getRetentionDays(): RetentionDays {
  return process.env.ENV === 'production'
    ? RetentionDays.FIVE_DAYS
    : RetentionDays.ONE_DAY;
}
