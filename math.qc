/*
 * math.qc
 *
 * Author: Joshua Skelton joshua.skelton@gmail.com
 *
 * A collection of helpful math functions.
 */

// Forward declarations
float(float value, float minValue, float maxValue) clamp;
float(float a, float b) mod;
float(float x) sign;
float(float value, float minValue, float maxValue) wrap;

/*
 * clamp
 *
 * Limits the given value to the given range.
 *
 * value: A number
 *
 * minValue: The minimum value of the range
 *
 * maxValue: The maximum value of the range
 *
 * Returns: A number within the given range.
 */
float(float value, float minValue, float maxValue) clamp = {
    if (value < minValue) {
        return minValue;
    }
    else if (value > maxValue) {
        return maxValue;
    }

    return value;
};

/*
 * mod
 *
 * Returns the remainder after the division of a by n
 *
 * a: The dividend
 *
 * b: The divisor
 *
 * Returns: The remainder of a divided by n
 */
float(float a, float n) mod = {
    return a - (n * floor(a / n));
};

/*
 * sign
 *
 * Returns an indication of the sign of the given number.
 *
 * x: A number
 *
 * Returns: -1 if x < 0, 0 if x == 0, 1 if x > 0.
 */
float(float x) sign = {
    if (x > 0) {
        return 1;
    }
    else if (x < 0) {
        return -1;
    }

    return 0;
};

/*
 * wrap
 *
 * Limits the given value to the given range and will wrap the value to the
 * the other end of the range if exceeded.
 *
 * value: A number
 *
 * minValue: The minimum value of the range
 *
 * maxValue: The maximum value of the range
 *
 * Returns: A number within the given range.
 */
float(float value, float minValue, float maxValue) wrap = {
    local float range = maxValue - minValue;

    return mod(value - minValue, range + 1) + minValue;
};



float(float a, float b, float mix) lerp =
{
    if (mix <= 0) return a;
    if (mix >= 1) return b;
    return (b * mix + a * ( 1 - mix ) );
}

vector(vector a, vector b, float mix) lerpVector =
{
    if (mix <= 0) return a;
    if (mix >= 1) return b;
    return (b * mix + a * ( 1 - mix ) );
}

// for a relaxing lerp: hermite lerp.
float(float a, float b, float mix) lerpHermite =
{
    if (mix <= 0) return a;
    if (mix >= 1) return b;
    
    local float h01;
    
    h01 = mix * mix;
    h01 *= 3 - 2 * mix;
    
    return (b * h01 + a * ( 1 - h01 ) );
}

vector(vector a, vector b, float mix) lerpVectorHermite =
{
    if (mix <= 0) return a;
    if (mix >= 1) return b;

    local float h01;
    
    h01 = mix * mix;
    h01 *= 3 - 2 * mix;
    
    return (b * h01 + a * ( 1 - h01 ) );
}

float(float anga, float angb) angledif =
{
    float dif;
    dif = fabs(anga - angb);
    if (dif > 180)
        dif = 360 - dif;
    return dif;
}

float(vector ang, vector base_ang, vector offset) isInAngle = {
    if (angledif(ang_x, base_ang_x) > offset_x || angledif(ang_y, base_ang_y) > offset_y)
        return FALSE;
    else
        return TRUE;
};


// normalizes an angle vector to the 0/+359 range
vector(vector ang) normalizeAngles = {

    ang_x = ang_x - floor(ang_x/360) * 360;
    ang_y = ang_y - floor(ang_y/360) * 360;
    ang_z = ang_z - floor(ang_z/360) * 360;

    /*
    while (ang_x > 360)
        ang_x = ang_x - 360;

    while (ang_x < 0)
        ang_x = ang_x + 360;

    while (ang_y > 360)
        ang_y = ang_y - 360;

    while (ang_y < 0)
        ang_y = ang_y + 360;

    while (ang_z > 360)
        ang_z = ang_z - 360;

    while (ang_z < 0)
        ang_z = ang_z + 360;
    */
    return ang;
};

// normalizes an angle vector to the -180/+179 range
vector(vector ang) normalizeAngles180 = {
    ang_x = ((ang_x+180) - floor((ang_x+180)/360) * 360) - 180;
    ang_y = ((ang_y+180) - floor((ang_y+180)/360) * 360) - 180;
    ang_z = ((ang_z+180) - floor((ang_z+180)/360) * 360) - 180;

    /*
    while (ang_x > 180)
        ang_x = ang_x - 360;

    while (ang_x < -180)
        ang_x = ang_x + 360;

    while (ang_y > 180)
        ang_y = ang_y - 360;

    while (ang_y < -180)
        ang_y = ang_y + 360;

    while (ang_z > 180)
        ang_z = ang_z - 360;

    while (ang_z < -180)
        ang_z = ang_z + 360;
    */
    return ang;
};