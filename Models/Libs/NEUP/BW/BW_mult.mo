within ;
model BW_mult
  extends Interfaces.SISO;


equation
  y = (0.1 / sqrt(1+(x/650)^8)) + 0.9;
  annotation (
    Documentation(info="<html>
<p>
This blocks computes the output <strong>y</strong>
as <em>product</em> of the two inputs <strong>u1</strong> and <strong>u2</strong>:
</p>
<blockquote><pre>
y = (0.1 / sqrt(1+(x/650)^8)) + 0.9;
</pre></blockquote>

</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-100,60},{-40,60},{-30,40}}, color={0,0,127}),
        Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={0,0,127}),
        Line(points={{50,0},{100,0}}, color={0,0,127}),
        Line(points={{-30,0},{30,0}}),
        Line(points={{-15,25.99},{15,-25.99}}),
        Line(points={{-15,-25.99},{15,25.99}}),
        Ellipse(lineColor={0,0,127}, extent={{-50,-50},{50,50}})}));
end BW_mult;
