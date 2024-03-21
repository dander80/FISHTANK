model twotTankscontrolOutletUncoupled "Show the treatment of empty tanks"
  extends Modelica.Icons.Example;
  Modelica.Fluid.Vessels.OpenTank tank1(
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    crossArea= 0.1,
    height= 10, level(start = 5),
    level_start= 5,
    nPorts=2,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1),
        Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1)})                                                                                                                                                  annotation (Placement(visible = true, transformation(extent = {{-70, 10}, {-30, 50}}, rotation = 0)));

  Modelica.Fluid.Vessels.OpenTank tank2( redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,                                                            crossArea = 0.1, height = 10, level(start = 5), level_start = 5, nPorts=2,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1),
        Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.1)})                                                                                                                                                                                                         annotation (
    Placement(visible = true, transformation(extent = {{26, 8}, {66, 48}}, rotation = 0)));
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                                   annotation (Placement(visible = true, transformation(extent = {{74, 74}, {94, 94}}, rotation = 0)));
  Modelica.Fluid.Fittings.GenericResistances.VolumeFlowRate R1(a = 1, b = 1, redeclare
      package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)                                                                                                 annotation (
    Placement(visible = true, transformation(origin = {-50, -38}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Sources.Boundary_pT y1_outlet(nPorts = 1,     redeclare
      package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)  annotation (
    Placement(visible = true, transformation(origin = {-60, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Fittings.GenericResistances.VolumeFlowRate R2( redeclare
      package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    a=1,                                                                                                                                           b = 1) annotation (
    Placement(visible = true, transformation(origin = {46, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Sources.Boundary_pT y2_outlet(nPorts = 1, redeclare package
      Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater) annotation (
    Placement(visible = true, transformation(origin = {36, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T x1_inlet( redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, nPorts = 1, use_m_flow_in = true)  annotation (
    Placement(visible = true, transformation(origin={-78,74},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T x2_inlet( redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,nPorts = 1, use_m_flow_in = true)  annotation (
    Placement(visible = true, transformation(origin = {18, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant setpoint_Tank1(k = 5)  annotation (
    Placement(visible = true, transformation(origin={-196,82},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.PID pid_Tank1(Td = 0, Ti = 0.1,k = 1)  annotation (
    Placement(visible = true, transformation(origin={-128,82},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression level_Tank1(y = tank1.level)  annotation (
    Placement(visible = true, transformation(origin={-196,54},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback_Tank1 annotation (
    Placement(visible = true, transformation(origin={-162,82},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback_Tank2 annotation (
    Placement(visible = true, transformation(origin = {-160, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression level_Tank2(y = tank2.level) annotation (
    Placement(visible = true, transformation(origin={-198,108},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.PID pid_Tank2(Td = 0, Ti = 0.1,k = 1) annotation (
    Placement(visible = true, transformation(origin = {-128, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y=if time < 200 then 5
         else 7)
    annotation (Placement(transformation(extent={{-208,122},{-188,142}})));
equation
  connect(R1.port_b, y1_outlet.ports[1]) annotation (
    Line(points = {{-50, -48}, {-50, -76}}, color = {0, 127, 255}));
  connect(R1.port_a, tank1.ports[1]) annotation (
    Line(points={{-50,-28},{-50,-10},{-50,10},{-54,10}},
                                           color = {0, 127, 255}));
  connect(R2.port_b, y2_outlet.ports[1]) annotation (
    Line(points = {{46, -50}, {46, -78}}, color = {0, 127, 255}));
  connect(R2.port_a, tank2.ports[1]) annotation (
    Line(points={{46,-30},{46,-12},{46,8},{42,8}},
                                        color = {0, 127, 255}));
  connect(x1_inlet.ports[1], tank1.ports[2]) annotation (
    Line(points={{-68,74},{-34,74},{-34,16},{-46,16},{-46,10}},
                                                     color = {0, 127, 255}));
  connect(x2_inlet.ports[1], tank2.ports[2]) annotation (
    Line(points={{28,76},{62,76},{62,14},{50,14},{50,8}},
                                                 color = {0, 127, 255}));
  connect(setpoint_Tank1.y, feedback_Tank1.u1) annotation (
    Line(points={{-185,82},{-170,82}},      color = {0, 0, 127}));
  connect(feedback_Tank1.y, pid_Tank1.u) annotation (
    Line(points={{-153,82},{-140,82}},      color = {0, 0, 127}));
  connect(level_Tank1.y, feedback_Tank1.u2) annotation (
    Line(points={{-185,54},{-162,54},{-162,74}},      color = {0, 0, 127}));
  connect(pid_Tank1.y, x1_inlet.m_flow_in) annotation (
    Line(points={{-117,82},{-88,82}},                 color = {0, 0, 127}));
  connect(feedback_Tank2.y, pid_Tank2.u) annotation (
    Line(points={{-151,132},{-140,132}},      color = {0, 0, 127}));
  connect(level_Tank2.y, feedback_Tank2.u2) annotation (
    Line(points={{-187,108},{-160,108},{-160,124}},      color = {0, 0, 127}));
  connect(pid_Tank2.y, x2_inlet.m_flow_in) annotation (
    Line(points={{-117,132},{-8,132},{-8,84},{8,84}},
                                                    color = {0, 0, 127}));
  connect(realExpression.y, feedback_Tank2.u1)
    annotation (Line(points={{-187,132},{-168,132}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=500,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_Commands(file = "modelica://Modelica/Resources/Scripts/Dymola/Fluid/EmptyTanks/plot level and port.p.mos" "plot level and port.p"),
    Documentation(info = "<html>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Examples/Tanks/EmptyTanks.png\" border=\"1\"
   alt=\"EmptyTanks.png\">
</html>"),
    uses(Modelica(version = "4.0.0")),
    Diagram(coordinateSystem(extent={{-220,-100},{100,160}})),
    Icon(coordinateSystem(extent={{-220,-100},{100,160}})));
end twotTankscontrolOutletUncoupled;