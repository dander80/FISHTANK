within TRANSFORM.Math;
function cubicHermiteSplineLinearExtrapolation   "Interpolate using a cubic Hermite spline with linear extrapolation"
  extends TRANSFORM.Icons.Function;
  input Real x "Abscissa value";
  input Real x1 "Lower abscissa value";
  input Real x2 "Upper abscissa value";
  input Real y1 "Lower ordinate value";
  input Real y2 "Upper ordinate value";
  input Real y1d "Lower gradient";
  input Real y2d "Upper gradient";
  output Real y "Interpolated ordinate value";
algorithm
  if (x > x1 and x < x2) then
    y := cubicHermiteSpline(
      x=x,
      x1=x1,
      x2=x2,
      y1=y1,
      y2=y2,
      y1d=y1d,
      y2d=y2d);
  elseif x <= x1 then
    // linear extrapolation
    y := y1 + (x - x1)*y1d;
  else
    y := y2 + (x - x2)*y2d;
  end if;
  annotation (smoothOrder=1, Documentation(info="<html>
<p>
For <i>x<sub>1</sub> &lt; x &lt; x<sub>2</sub></i>, this function interpolates
using cubic hermite spline. For <i>x</i> outside this interval, the function
linearly extrapolates.
</p></html>"));
end cubicHermiteSplineLinearExtrapolation;