#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT /* we want efficiency */
#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#ifdef __cplusplus
} /* extern "C" */
#endif

#define NEED_newSVpvn_flags
#include "ppport.h"

#define SECONDS_PER_SECOND         (unsigned int)1
#define SECONDS_PER_MINUTE         (unsigned int)(SECONDS_PER_SECOND * 60)
#define SECONDS_PER_HOUR           (unsigned int)(SECONDS_PER_MINUTE * 60)
#define SECONDS_PER_DAY            (unsigned int)(SECONDS_PER_HOUR   * 24)
#define SECONDS_PER_YEAR           (unsigned int)(SECONDS_PER_DAY    * 365)
#define EPOCH_BASE_YEAR            (unsigned int)1970
#define EPOCH_BASE_YEAR_AS_SECONDS (unsigned int)(EPOCH_BASE_YEAR * SECONDS_PER_YEAR)
#define EPOCH_BASE_LEAP_YEARS      (unsigned int)(EPOCH_BASE_YEAR / 4 - EPOCH_BASE_YEAR / 100 + EPOCH_BASE_YEAR / 400 + 1)

const static unsigned int MONTH2DAYS[] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
unsigned int timegm_nocheck(
  const unsigned int sec,
  const unsigned int min,
  const unsigned int hour,
  const unsigned int mday,
  const unsigned int month,
  const unsigned int year
) {
  const unsigned int leap_years   = year / 4 - year / 100 + year / 400 - EPOCH_BASE_LEAP_YEARS;
  const unsigned int is_leap_year = year % 4 ? 0 : year % 100 ? 1 : year % 400 ? 0 : 1;
  const unsigned int base =
         year * SECONDS_PER_YEAR - EPOCH_BASE_YEAR_AS_SECONDS
       + (leap_years + MONTH2DAYS[month] + mday) * SECONDS_PER_DAY
       + hour * SECONDS_PER_HOUR
       + min  * SECONDS_PER_MINUTE
       + sec  * SECONDS_PER_SECOND;

  return (month < 2) ? base - is_leap_year * SECONDS_PER_DAY : base;
}

MODULE = Time::Local::Lite    PACKAGE = Time::Local::Lite PREFIX = xs_

PROTOTYPES: DISABLE

unsigned int
xs_timegm_nocheck(sec, min, hour, mday, month, year)
  unsigned int sec;
  unsigned int min;
  unsigned int hour;
  unsigned int mday;
  unsigned int month;
  unsigned int year;
CODE:
{
  RETVAL = timegm_nocheck(sec, min, hour, mday, month, year);
}
OUTPUT:
  RETVAL

unsigned int
xs_timegm(sec, min, hour, mday, month, year)
  unsigned int sec;
  unsigned int min;
  unsigned int hour;
  unsigned int mday;
  unsigned int month;
  unsigned int year;
INIT:
  static unsigned int MONTH_DAYS[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
CODE:
{
  if (month > 11) {
    croak("Month \"%d\" out of range 0..11", month);
  }
  if (mday < 1 || mday > MONTH_DAYS[month]) {
    croak("Day \"%d\" out of range 1..%d", mday, MONTH_DAYS[month]);
  }
  if (hour > 23) {
    croak("Hour \"%d\" out of range 0..23", hour);
  }
  if (min > 59) {
    croak("Minute \"%d\" out of range 0..59", min);
  }
  if (sec > 59) {
    croak("Second \"%d\" out of range 0..59", sec);
  }
  RETVAL = timegm_nocheck(sec, min, hour, mday, month, year);
}
OUTPUT:
  RETVAL
