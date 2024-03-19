within NEUP.FMUs;
model BOP_FMU_keeper
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-336,126},{-316,146}}),
        iconTransformation(extent={{-336,126},{-316,146}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_b(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-342,-138},{-322,-118}}),
        iconTransformation(extent={{-342,-138},{-322,-118}})));
  TRANSFORM.Fluid.Machines.SteamTurbine HPTurbine(redeclare package Medium =
        Modelica.Media.Water.StandardWater,
    p_a_start(displayUnit="MPa") = 3500000,
    p_b_start(displayUnit="MPa") = 1000000,
    use_T_start=false,
    h_a_start=3e6,
    m_flow_start=67,                        use_Stodola=false)
    annotation (Placement(transformation(extent={{66,150},{86,170}})));
  TRANSFORM.Fluid.Machines.SteamTurbine LPTurbine(redeclare package Medium =
        Modelica.Media.Water.StandardWater,
    p_a_start(displayUnit="MPa") = 1000000,
    p_b_start(displayUnit="kPa") = 10000,
    use_T_start=false,
    h_a_start=2.7e6,
    m_flow_start=(1 - 0.18)*67,             use_Stodola=false)
    annotation (Placement(transformation(extent={{184,150},{204,170}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow Cond_Pump(redeclare package
      Medium = Modelica.Media.Water.StandardWater, m_flow_nominal=(1 - 0.18)*67)
    annotation (Placement(transformation(extent={{184,-186},{164,-166}})));
  TRANSFORM.Fluid.Volumes.IdealCondenser condenser(redeclare package Medium =
        Modelica.Media.Water.StandardWater, p(displayUnit="kPa") = 10000)
    annotation (Placement(transformation(extent={{200,-160},{220,-140}})));
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionVolume(redeclare package
      Medium = Modelica.Media.Water.StandardWater,
    p_start(displayUnit="MPa") = 1000000,
    use_T_start=false,
    h_start=2.7e6,
    V=1)
    annotation (Placement(transformation(extent={{140,176},{120,156}})));
  TRANSFORM.Fluid.FittingsAndResistances.NominalLoss Bleed(redeclare package
      Medium = Modelica.Media.Water.StandardWater,
    dp_nominal(displayUnit="Pa") = 1e4,
    m_flow_nominal=0.18*67,
    p_nominal(displayUnit="Pa") = 1e6,
    T_nominal=726.15)                              annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={130,-14})));
  TRANSFORM.Fluid.Volumes.MixingVolume OFWH(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_start(displayUnit="MPa") = 1000000,
    use_T_start=false,
    h_start=data.h_steam_cold,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=1),
    nPorts_b=2,
    nPorts_a=1)
    annotation (Placement(transformation(extent={{88,-186},{108,-166}})));
  TRANSFORM.Electrical.PowerConverters.Generator generator
    annotation (Placement(transformation(extent={{222,150},{242,170}})));
  TRANSFORM.Electrical.Sources.FrequencySource
                            boundary
    annotation (Placement(transformation(extent={{332,150},{312,170}})));
  TRANSFORM.Electrical.Sensors.PowerSensor sensorW
    annotation (Placement(transformation(extent={{266,150},{286,170}})));
  NHES.Systems.PrimaryHeatSystem.SMR_Generic.Components.Data.Data_GenericModule
                                     data(length_steamGenerator_tube=36)
    annotation (Placement(transformation(extent={{322,184},{338,200}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow Cond_Pump1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=true,
    m_flow_nominal=67)
    annotation (Placement(transformation(extent={{78,-186},{58,-166}})));
  Modelica.Blocks.Interfaces.RealInput FW_Pump annotation (Placement(
        transformation(extent={{112,-162},{82,-132}}),iconTransformation(extent={{-15,-15},
            {15,15}},
        rotation=90,
        origin={115,-105})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate_fwp(redeclare package Medium
      = Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-124,-186},{-144,-166}})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate_steam(redeclare package
      Medium = Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{24,156},{44,176}})));
  Modelica.Fluid.Sensors.Pressure pressure_Tvalve(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{4,30},{24,50}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-324,22},{-304,42}})));
  Modelica.Blocks.Interfaces.RealInput T_valve1 annotation (Placement(
        transformation(extent={{-322,164},{-302,184}}), iconTransformation(
          extent={{14,-14},{-14,14}},
        rotation=90,
        origin={-278,120})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_start=100000,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-228,156},{-208,136}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV2(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-224,22},{-204,42}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV3(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-224,-118},{-204,-98}})));
  Modelica.Blocks.Sources.RealExpression Sensor_W(y=sensorW.y)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={326,98})));
  Modelica.Blocks.Interfaces.RealOutput W_Sensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={326,52}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-166,-110})));
  Modelica.Fluid.Sensors.MassFlowRate TCV3_mdot(redeclare package Medium =
        Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-38,-86},{-24,-72}})));
  Modelica.Blocks.Math.Product PID_prod annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=0,
        origin={-249,-89})));
  Modelica.Blocks.Sources.Ramp     no_mult(
    height=0,
    duration=1.21e6,
    offset=1)
    "use to prevent actuator degradation"
    annotation (Placement(transformation(extent={{8,-8},{-8,8}},
        rotation=180,
        origin={-276,-94})));
  TRANSFORM.Fluid.Volumes.SimpleVolume pre_leak_vol_3(redeclare package Medium
      = Modelica.Media.Water.StandardWater, showName=false)
    annotation (Placement(transformation(extent={{-194,-118},{-174,-98}})));
  TRANSFORM.Fluid.BoundaryConditions.FixedBoundary leak_boundary_3(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T=673.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-10,-108})));
  TRANSFORM.Fluid.FittingsAndResistances.NominalLoss leak_resistor_3(showName=
        false, showDP=false)
    annotation (Placement(transformation(extent={{-46,-118},{-26,-98}})));
  TRANSFORM.Fluid.FittingsAndResistances.MultiPort multiPort_3(redeclare
      package Medium = Modelica.Media.Water.StandardWater, nPorts_b=2)
    annotation (Placement(transformation(extent={{-132,-120},{-122,-96}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow leak_pump_3(use_input=true,
      m_flow_nominal=0.16)
    annotation (Placement(transformation(extent={{-72,-98},{-52,-118}})));
  Modelica.Blocks.Sources.Ramp leak_ramp3(height=0, duration=1.21e6)
                    annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-82,-126})));
  TRANSFORM.Fluid.FittingsAndResistances.MultiPort multiPort_1(redeclare
      package Medium = Modelica.Media.Water.StandardWater, nPorts_b=2)
    annotation (Placement(transformation(extent={{-128,158},{-118,134}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow leak_pump_1(use_input=true,
      m_flow_nominal=0.16)
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));
  TRANSFORM.Fluid.FittingsAndResistances.NominalLoss leak_resistor_1(showName=
        false, showDP=false)
    annotation (Placement(transformation(extent={{-66,140},{-46,160}})));
  Modelica.Blocks.Sources.Ramp leak_ramp2(height=0, duration=1.21e6)
                    annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-128,166})));
  TRANSFORM.Fluid.BoundaryConditions.FixedBoundary leak_boundary_1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T=673.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-34,166})));
  TRANSFORM.Fluid.Volumes.SimpleVolume pre_leak_vol_1(redeclare package Medium
      = Modelica.Media.Water.StandardWater, showName=false)
    annotation (Placement(transformation(extent={{-182,136},{-162,156}})));
  Modelica.Fluid.Sensors.MassFlowRate TCV1_mdot(redeclare package Medium =
        Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-36,124},{-22,138}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume pre_leak_vol_2(redeclare package Medium
      = Modelica.Media.Water.StandardWater, showName=false)
    annotation (Placement(transformation(extent={{-144,22},{-124,42}})));
  TRANSFORM.Fluid.FittingsAndResistances.MultiPort multiPort_2(redeclare
      package Medium = Modelica.Media.Water.StandardWater, nPorts_b=2)
    annotation (Placement(transformation(extent={{-110,44},{-100,20}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow leak_pump_2(use_input=true,
      m_flow_nominal=0.16)
    annotation (Placement(transformation(extent={{-82,38},{-62,58}})));
  TRANSFORM.Fluid.BoundaryConditions.FixedBoundary leak_boundary_2(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T=673.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-26,64})));
  TRANSFORM.Fluid.FittingsAndResistances.NominalLoss leak_resistor_2(showName=
        false, showDP=false)
    annotation (Placement(transformation(extent={{-58,38},{-38,58}})));
  Modelica.Blocks.Sources.Ramp leak_ramp1(height=0, duration=1.21e6)
                    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-89,73})));
  Modelica.Fluid.Sensors.MassFlowRate TCV2_mdot(redeclare package Medium =
        Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-32,22},{-16,38}})));
  Modelica.Blocks.Math.Product PID_mult_act_1 annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={-226,120})));
  Modelica.Blocks.Sources.Ramp actuator_ramp1(
    height=0,
    duration=1.21e6,
    offset=1)       annotation (Placement(transformation(
        extent={{7,7},{-7,-7}},
        rotation=180,
        origin={-279,123})));
  Modelica.Blocks.Sources.Ramp actuator_ramp2(
    height=0,
    duration=1.21e6,
    offset=1)       annotation (Placement(transformation(
        extent={{7,7},{-7,-7}},
        rotation=180,
        origin={-279,71})));
  Modelica.Blocks.Math.Product PID_mult_act_2 annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={-222,74})));
equation
  connect(LPTurbine.shaft_a, HPTurbine.shaft_b)
    annotation (Line(points={{184,160},{86,160}},
                                                color={0,0,0}));
  connect(LPTurbine.shaft_b, generator.shaft)
    annotation (Line(points={{204,160},{222,160}},
                                               color={0,0,0}));
  connect(generator.port, sensorW.port_a)
    annotation (Line(points={{242,160},{266,160}},
                                                 color={255,0,0}));
  connect(sensorW.port_b, boundary.port)
    annotation (Line(points={{286,160},{312,160}},
                                                 color={255,0,0}));
  connect(HPTurbine.portLP, teeJunctionVolume.port_2)
    annotation (Line(points={{86,166},{120,166}},
                                                color={0,127,255}));
  connect(teeJunctionVolume.port_1, LPTurbine.portHP)
    annotation (Line(points={{140,166},{184,166}},
                                               color={0,127,255}));
  connect(LPTurbine.portLP, condenser.port_a)
    annotation (Line(points={{204,166},{204,-138},{203,-138},{203,-143}},
                                                        color={0,127,255}));
  connect(condenser.port_b, Cond_Pump.port_a) annotation (Line(points={{210,
          -158},{210,-176},{184,-176}},color={0,127,255}));
  connect(Cond_Pump.port_b, OFWH.port_b[1]) annotation (Line(points={{164,-176},
          {134,-176},{134,-176.5},{104,-176.5}},
                                             color={0,127,255}));
  connect(teeJunctionVolume.port_3, Bleed.port_a) annotation (Line(points={{130,156},
          {130,-7}},                   color={0,127,255}));
  connect(Bleed.port_b, OFWH.port_b[2]) annotation (Line(points={{130,-21},{130,
          -175.5},{104,-175.5}},   color={0,127,255}));
  connect(Cond_Pump1.port_a, OFWH.port_a[1])
    annotation (Line(points={{78,-176},{92,-176}}, color={0,127,255}));
  connect(FW_Pump, Cond_Pump1.in_m_flow) annotation (Line(points={{97,-147},{
          82.5,-147},{82.5,-168.7},{68,-168.7}}, color={0,0,127}));
  connect(Cond_Pump1.port_b, massFlowRate_fwp.port_a) annotation (Line(points={{58,-176},
          {-124,-176}},                              color={0,127,255}));
  connect(massFlowRate_fwp.port_b, port_b) annotation (Line(points={{-144,-176},
          {-332,-176},{-332,-128}},          color={0,127,255}));
  connect(massFlowRate_steam.port_b, HPTurbine.portHP) annotation (Line(points={{44,166},
          {66,166}},                              color={0,127,255}));
  connect(pressure_Tvalve.port, massFlowRate_steam.port_a)
    annotation (Line(points={{14,30},{-2,30},{-2,166},{24,166}},
                                                   color={0,127,255}));
  connect(port_a, volume.port_a)
    annotation (Line(points={{-326,136},{-326,32},{-320,32}},
                                                   color={0,127,255}));
  connect(TCV2.port_a, volume.port_b)
    annotation (Line(points={{-224,32},{-274,32},{-274,34},{-290,34},{-290,32},
          {-308,32}},                              color={0,127,255}));
  connect(TCV1.port_a, volume.port_b) annotation (Line(points={{-228,146},{-294,
          146},{-294,32},{-308,32}}, color={0,127,255}));
  connect(volume.port_b, TCV3.port_a) annotation (Line(points={{-308,32},{-292,
          32},{-292,-108},{-224,-108}},
                                    color={0,127,255}));
  connect(Sensor_W.y, W_Sensor)
    annotation (Line(points={{326,87},{326,52}},    color={0,0,127}));
  connect(TCV3_mdot.port_b, pressure_Tvalve.port) annotation (Line(points={{-24,-79},
          {-2,-79},{-2,30},{14,30}},     color={0,127,255}));
  connect(TCV3.opening, PID_prod.y) annotation (Line(points={{-214,-100},{-214,
          -89},{-241.3,-89}},
                        color={0,0,127}));
  connect(T_valve1, PID_prod.u2) annotation (Line(points={{-312,174},{-258,174},
          {-258,-84.8},{-257.4,-84.8}},
                                      color={0,0,127}));
  connect(no_mult.y, PID_prod.u1)
    annotation (Line(points={{-267.2,-94},{-262,-94},{-262,-92},{-257.4,-92},{
          -257.4,-93.2}},                                color={0,0,127}));
  connect(pre_leak_vol_3.port_b, multiPort_3.port_a)
    annotation (Line(points={{-178,-108},{-132,-108}}, color={0,127,255}));
  connect(leak_resistor_3.port_a, leak_pump_3.port_b)
    annotation (Line(points={{-43,-108},{-52,-108}}, color={0,127,255}));
  connect(leak_resistor_3.port_b, leak_boundary_3.ports[1])
    annotation (Line(points={{-29,-108},{-20,-108}}, color={0,127,255}));
  connect(multiPort_3.ports_b[1], TCV3_mdot.port_a) annotation (Line(points={{
          -122,-105.6},{-122,-104},{-78,-104},{-78,-79},{-38,-79}}, color={0,
          127,255}));
  connect(leak_pump_3.in_m_flow, leak_ramp3.y) annotation (Line(points={{-62,
          -115.3},{-62,-126},{-73.2,-126}}, color={0,0,127}));
  connect(pre_leak_vol_3.port_a, TCV3.port_b)
    annotation (Line(points={{-190,-108},{-204,-108}}, color={0,127,255}));
  connect(leak_pump_3.port_a, multiPort_3.ports_b[2]) annotation (Line(points={
          {-72,-108},{-114,-108},{-114,-104},{-122,-104},{-122,-110.4}}, color=
          {0,127,255}));
  connect(leak_pump_1.port_a, multiPort_1.ports_b[1]) annotation (Line(points={
          {-100,150},{-108,150},{-108,143.6},{-118,143.6}}, color={0,127,255}));
  connect(pre_leak_vol_1.port_b, multiPort_1.port_a)
    annotation (Line(points={{-166,146},{-128,146}}, color={0,127,255}));
  connect(leak_resistor_1.port_a, leak_pump_1.port_b)
    annotation (Line(points={{-63,150},{-80,150}}, color={0,127,255}));
  connect(leak_pump_1.in_m_flow, leak_ramp2.y) annotation (Line(points={{-90,
          157.3},{-90,166},{-119.2,166}}, color={0,0,127}));
  connect(leak_resistor_1.port_b, leak_boundary_1.ports[1]) annotation (Line(
        points={{-49,150},{-34,150},{-34,156}}, color={0,127,255}));
  connect(pre_leak_vol_1.port_a, TCV1.port_b)
    annotation (Line(points={{-178,146},{-208,146}}, color={0,127,255}));
  connect(multiPort_1.ports_b[2], TCV1_mdot.port_a) annotation (Line(points={{
          -118,148.4},{-108,148.4},{-108,131},{-36,131}}, color={0,127,255}));
  connect(TCV1_mdot.port_b, pressure_Tvalve.port) annotation (Line(points={{-22,
          131},{-2,131},{-2,30},{14,30}}, color={0,127,255}));
  connect(leak_resistor_2.port_b, leak_boundary_2.ports[1])
    annotation (Line(points={{-41,48},{-26,48},{-26,54}}, color={0,127,255}));
  connect(pre_leak_vol_2.port_b, multiPort_2.port_a)
    annotation (Line(points={{-128,32},{-110,32}}, color={0,127,255}));
  connect(leak_resistor_2.port_a, leak_pump_2.port_b)
    annotation (Line(points={{-55,48},{-62,48}}, color={0,127,255}));
  connect(TCV2.port_b, pre_leak_vol_2.port_a)
    annotation (Line(points={{-204,32},{-140,32}}, color={0,127,255}));
  connect(multiPort_2.ports_b[1], TCV2_mdot.port_a) annotation (Line(points={{
          -100,29.6},{-36,29.6},{-36,30},{-32,30}}, color={0,127,255}));
  connect(leak_ramp1.y, leak_pump_2.in_m_flow) annotation (Line(points={{-81.3,
          73},{-72,73},{-72,55.3}}, color={0,0,127}));
  connect(TCV2_mdot.port_b, pressure_Tvalve.port)
    annotation (Line(points={{-16,30},{14,30}}, color={0,127,255}));
  connect(leak_pump_2.port_a, multiPort_2.ports_b[2]) annotation (Line(points={
          {-82,48},{-92,48},{-92,34.4},{-100,34.4}}, color={0,127,255}));
  connect(actuator_ramp1.y, PID_mult_act_1.u2)
    annotation (Line(points={{-271.3,123},{-233.2,123.6}}, color={0,0,127}));
  connect(T_valve1, PID_mult_act_1.u1) annotation (Line(points={{-312,174},{
          -258,174},{-258,116},{-234,116},{-234,112},{-233.2,112},{-233.2,116.4}},
        color={0,0,127}));
  connect(PID_mult_act_1.y, TCV1.opening) annotation (Line(points={{-219.4,120},
          {-218,120},{-218,138}}, color={0,0,127}));
  connect(actuator_ramp2.y, PID_mult_act_2.u1) annotation (Line(points={{-271.3,
          71},{-270,71},{-270,70},{-229.2,70},{-229.2,70.4}}, color={0,0,127}));
  connect(PID_mult_act_2.u2, T_valve1) annotation (Line(points={{-229.2,77.6},{
          -258,77.6},{-258,174},{-312,174}}, color={0,0,127}));
  connect(PID_mult_act_2.y, TCV2.opening) annotation (Line(points={{-215.4,74},
          {-208,74},{-208,48},{-214,48},{-214,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-340,
            -200},{340,200}}), graphics={Bitmap(extent={{-344,-116},{202,164}},
            fileName="modelica://NEUP/../../BOP.png")}),         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-340,-200},{340,
            200}})));
end BOP_FMU_keeper;
