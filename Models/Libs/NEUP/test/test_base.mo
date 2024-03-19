within NEUP.test;
model test_base
  Modelica.Blocks.Sources.Ramp ramp(height=param_1, duration=10)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  parameter Real param_1 = 0 "Output bias. May improve simulation";
equation
  connect(ramp.y, y) annotation (Line(points={{1,0},{60,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end test_base;
