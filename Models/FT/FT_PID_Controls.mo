within FISHTANK;
model FT_PID_Controls

  Modelica.Blocks.Sources.Ramp     tank2_Setpoint(
    height=0,
    duration=400,
    offset=0.45,
    startTime=50)
    annotation (Placement(transformation(extent={{144,6},{124,26}})));
  Modelica.Blocks.Sources.Constant tank1_Setpoint(k=0.45)
    annotation (Placement(transformation(extent={{-134,6},{-114,26}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=if time < 200 then
        0.34375 else 0.50)
    annotation (Placement(transformation(extent={{-160,-40},{-112,-28}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=0.15,
    f=0.005,
    offset=0.4,
    startTime=400)
    annotation (Placement(transformation(extent={{-158,-18},{-138,2}})));
  EmptyTanks____ emptyTanks____
    annotation (Placement(transformation(extent={{-28,-20},{28,20}})));
  TRANSFORM.Controls.LimPID PID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti=1,
    Td=0.5,                      yMax=1, yMin=0)
    annotation (Placement(transformation(extent={{-78,6},{-58,26}})));
  TRANSFORM.Controls.LimPID PID2(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti=1,
    Td=0.5,                      yMax=1, yMin=0)
    annotation (Placement(transformation(extent={{70,6},{50,26}})));
equation
  connect(PID1.y, emptyTanks____.cv_pos_1)
    annotation (Line(points={{-57,16},{-26,16}}, color={0,0,127}));
  connect(emptyTanks____.t1_level, PID1.u_m) annotation (Line(points={{-48,8},{
          -48,-2},{-68,-2},{-68,4}}, color={0,0,127}));
  connect(emptyTanks____.cv_pos_2, PID2.y)
    annotation (Line(points={{26,16},{49,16}}, color={0,0,127}));
  connect(emptyTanks____.t2_level, PID2.u_m) annotation (Line(points={{39.2,
          12.4},{44,12.4},{44,-2},{60,-2},{60,4}}, color={0,0,127}));
  connect(tank2_Setpoint.y, PID2.u_s)
    annotation (Line(points={{123,16},{72,16}}, color={0,0,127}));
  connect(tank1_Setpoint.y, PID1.u_s)
    annotation (Line(points={{-113,16},{-80,16}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-160,-60},{160,60}})),
    Icon(coordinateSystem(extent={{-160,-60},{160,60}})),
    experiment(
      StopTime=1500,
      Interval=0.1,
      __Dymola_Algorithm="Esdirk45a"));
end FT_PID_Controls;
