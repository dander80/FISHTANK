within NEUP.BOP;
model NuScaleBOP_fwp_and_leak
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-338,78},{-318,98}}),
        iconTransformation(extent={{-338,78},{-318,98}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_b(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-340,-8},{-320,12}}),
        iconTransformation(extent={{-340,-8},{-320,12}})));
  TRANSFORM.Fluid.Machines.SteamTurbine HPTurbine(redeclare package Medium =
        Modelica.Media.Water.StandardWater,
    p_a_start(displayUnit="MPa") = 3500000,
    p_b_start(displayUnit="MPa") = 1000000,
    use_T_start=false,
    h_a_start=3e6,
    m_flow_start=67,                        use_Stodola=false)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  TRANSFORM.Fluid.Machines.SteamTurbine LPTurbine(redeclare package Medium =
        Modelica.Media.Water.StandardWater,
    p_a_start(displayUnit="MPa") = 1000000,
    p_b_start(displayUnit="kPa") = 10000,
    use_T_start=false,
    h_a_start=2.7e6,
    m_flow_start=(1 - 0.18)*67,             use_Stodola=false)
    annotation (Placement(transformation(extent={{58,60},{78,80}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow Cond_Pump(redeclare package
      Medium = Modelica.Media.Water.StandardWater, m_flow_nominal=(1 - 0.18)*67)
    annotation (Placement(transformation(extent={{22,-98},{2,-78}})));
  TRANSFORM.Fluid.Volumes.IdealCondenser condenser(redeclare package Medium =
        Modelica.Media.Water.StandardWater, p(displayUnit="kPa") = 10000)
    annotation (Placement(transformation(extent={{76,-98},{96,-78}})));
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionVolume(redeclare package
      Medium = Modelica.Media.Water.StandardWater,
    p_start(displayUnit="MPa") = 1000000,
    use_T_start=false,
    h_start=2.7e6,
    V=1)
    annotation (Placement(transformation(extent={{14,86},{-6,66}})));
  TRANSFORM.Fluid.FittingsAndResistances.NominalLoss Bleed(redeclare package
      Medium = Modelica.Media.Water.StandardWater,
    dp_nominal(displayUnit="Pa") = 1e4,
    m_flow_nominal=0.18*67,
    p_nominal(displayUnit="Pa") = 1e6,
    T_nominal=726.15)                              annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={12,6})));
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
    annotation (Placement(transformation(extent={{-38,-98},{-18,-78}})));
  TRANSFORM.Electrical.PowerConverters.Generator generator
    annotation (Placement(transformation(extent={{96,60},{116,80}})));
  TRANSFORM.Electrical.Sources.FrequencySource
                            boundary
    annotation (Placement(transformation(extent={{206,60},{186,80}})));
  TRANSFORM.Electrical.Sensors.PowerSensor sensorW
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  NHES.Systems.PrimaryHeatSystem.SMR_Generic.Components.Data.Data_GenericModule
                                     data(length_steamGenerator_tube=36)
    annotation (Placement(transformation(extent={{84,84},{100,100}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow Cond_Pump1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=true,
    m_flow_nominal=67)
    annotation (Placement(transformation(extent={{-48,-98},{-68,-78}})));
  Modelica.Blocks.Interfaces.RealInput FW_Pump annotation (Placement(
        transformation(extent={{-14,-72},{-44,-42}}), iconTransformation(extent={{15,-15},
            {-15,15}},
        rotation=90,
        origin={115,-105})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate_fwp(redeclare package Medium =
        Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-126,-96},{-146,-76}})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate_steam(redeclare package
      Medium = Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-102,66},{-82,86}})));
  Modelica.Fluid.Sensors.Pressure pressure_Tvalve(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-134,76},{-114,96}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-292,66},{-272,86}})));
  Modelica.Blocks.Interfaces.RealInput T_valve1 annotation (Placement(
        transformation(extent={{-324,116},{-304,136}}), iconTransformation(
          extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-290,130})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_start=100000,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-226,108},{-206,128}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV2(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-226,66},{-206,86}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV3(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-226,24},{-206,44}})));
  Modelica.Blocks.Sources.RealExpression Sensor_W(y=sensorW.y)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={206,-56})));
  Modelica.Blocks.Interfaces.RealOutput W_Sensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={206,-102}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-166,-110})));
  TRANSFORM.Fluid.Volumes.SimpleVolume pre_leak_vol(redeclare package Medium =
        Modelica.Media.Water.StandardWater, showName=false)
    annotation (Placement(transformation(extent={{-194,24},{-174,44}})));
  TRANSFORM.Fluid.BoundaryConditions.FixedBoundary leak_boundary(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T=673.15,
    nPorts=2) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-58,32})));
  TRANSFORM.Fluid.FittingsAndResistances.NominalLoss leak_resistor(showName=
        false, showDP=false)
    annotation (Placement(transformation(extent={{-104,6},{-84,26}})));
  TRANSFORM.Fluid.FittingsAndResistances.NominalLoss leak_resistor1(showName=
        false, showDP=false)
    annotation (Placement(transformation(extent={{-88,20},{-68,40}})));
  Modelica.Blocks.Sources.TimeTable LF_profilev1(table=[0,100; 86400,100;
        108000,100; 109200,80; 130800,80; 132000,100; 150000,100; 150600,90;
        175800,90; 176400,100; 280800,100; 282000,80; 303600,80; 304800,100;
        363600,100; 364200,90; 375000,90; 375600,100; 453600,100; 454800,80;
        476400,80; 477600,100; 640800,100; 641400,90; 655800,90; 656400,100;
        712800,100; 714000,80; 735600,80; 736800,100; 885600,100; 886800,80;
        908400,80; 909600,100; 975600,100; 976200,90; 994200,90; 994800,100;
        1058400,100; 1059600,80; 1081200,80; 1082400,100; 1123200,100; 1209600,
        100])
    annotation (Placement(transformation(extent={{-196,-58},{-176,-38}})));
  Modelica.Blocks.Sources.TimeTable LF_sample(table=[0,0; 86400,0.008; 108000,
        0.016; 108900,0.024; 130500,0.032; 131400,0.04; 194400,0.048; 195300,
        0.056; 216900,0.064; 217800,0.072; 280800,0.08; 281700,0.088; 303300,
        0.096; 304200,0.104; 367200,0.112; 368100,0.12; 389700,0.128; 390600,
        0.136; 518400,0.144])
    annotation (Placement(transformation(extent={{-196,-20},{-176,0}})));
  TRANSFORM.Fluid.FittingsAndResistances.MultiPort multiPort(redeclare package
      Medium = Modelica.Media.Water.StandardWater, nPorts_b=3)
    annotation (Placement(transformation(extent={{-162,24},{-154,44}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump1(use_input=true,
      m_flow_nominal=0.16)
    annotation (Placement(transformation(extent={{-122,40},{-102,20}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump(use_input=true,
      m_flow_nominal=0.16)
    annotation (Placement(transformation(extent={{-140,26},{-120,6}})));
equation
  connect(LPTurbine.shaft_a, HPTurbine.shaft_b)
    annotation (Line(points={{58,70},{-40,70}}, color={0,0,0}));
  connect(LPTurbine.shaft_b, generator.shaft)
    annotation (Line(points={{78,70},{96,70}}, color={0,0,0}));
  connect(generator.port, sensorW.port_a)
    annotation (Line(points={{116,70},{140,70}}, color={255,0,0}));
  connect(sensorW.port_b, boundary.port)
    annotation (Line(points={{160,70},{186,70}}, color={255,0,0}));
  connect(HPTurbine.portLP, teeJunctionVolume.port_2)
    annotation (Line(points={{-40,76},{-6,76}}, color={0,127,255}));
  connect(teeJunctionVolume.port_1, LPTurbine.portHP)
    annotation (Line(points={{14,76},{58,76}}, color={0,127,255}));
  connect(LPTurbine.portLP, condenser.port_a)
    annotation (Line(points={{78,76},{79,76},{79,-81}}, color={0,127,255}));
  connect(condenser.port_b, Cond_Pump.port_a) annotation (Line(points={{86,-96},
          {56,-96},{56,-88},{22,-88}}, color={0,127,255}));
  connect(Cond_Pump.port_b, OFWH.port_b[1]) annotation (Line(points={{2,-88},{
          -10,-88},{-10,-88.5},{-22,-88.5}}, color={0,127,255}));
  connect(teeJunctionVolume.port_3, Bleed.port_a) annotation (Line(points={{4,
          66},{4,24},{12,24},{12,13}}, color={0,127,255}));
  connect(Bleed.port_b, OFWH.port_b[2]) annotation (Line(points={{12,-1},{-6,-1},
          {-6,-87.5},{-22,-87.5}}, color={0,127,255}));
  connect(Cond_Pump1.port_a, OFWH.port_a[1])
    annotation (Line(points={{-48,-88},{-34,-88}}, color={0,127,255}));
  connect(FW_Pump, Cond_Pump1.in_m_flow) annotation (Line(points={{-29,-57},{
          -43.5,-57},{-43.5,-80.7},{-58,-80.7}}, color={0,0,127}));
  connect(Cond_Pump1.port_b, massFlowRate_fwp.port_a) annotation (Line(points={
          {-68,-88},{-98,-88},{-98,-86},{-126,-86}}, color={0,127,255}));
  connect(massFlowRate_fwp.port_b, port_b) annotation (Line(points={{-146,-86},
          {-328,-86},{-328,2},{-330,2}},     color={0,127,255}));
  connect(massFlowRate_steam.port_b, HPTurbine.portHP) annotation (Line(points={{-82,76},
          {-60,76}},                              color={0,127,255}));
  connect(pressure_Tvalve.port, massFlowRate_steam.port_a)
    annotation (Line(points={{-124,76},{-102,76}}, color={0,127,255}));
  connect(port_a, volume.port_a)
    annotation (Line(points={{-328,88},{-308,88},{-308,76},{-288,76}},
                                                   color={0,127,255}));
  connect(TCV2.port_a, volume.port_b)
    annotation (Line(points={{-226,76},{-276,76}}, color={0,127,255}));
  connect(TCV1.port_a, volume.port_b) annotation (Line(points={{-226,118},{-250,
          118},{-250,76},{-276,76}}, color={0,127,255}));
  connect(T_valve1, TCV1.opening)
    annotation (Line(points={{-314,126},{-216,126}}, color={0,0,127}));
  connect(T_valve1, TCV2.opening) annotation (Line(points={{-314,126},{-260,126},
          {-260,84},{-216,84}}, color={0,0,127}));
  connect(T_valve1, TCV3.opening) annotation (Line(points={{-314,126},{-260,126},
          {-260,42},{-216,42}}, color={0,0,127}));
  connect(TCV2.port_b, pressure_Tvalve.port)
    annotation (Line(points={{-206,76},{-124,76}}, color={0,127,255}));
  connect(TCV1.port_b, pressure_Tvalve.port) annotation (Line(points={{-206,118},
          {-164,118},{-164,76},{-124,76}}, color={0,127,255}));
  connect(volume.port_b, TCV3.port_a) annotation (Line(points={{-276,76},{-250,
          76},{-250,34},{-226,34}}, color={0,127,255}));
  connect(Sensor_W.y, W_Sensor)
    annotation (Line(points={{206,-67},{206,-102}}, color={0,0,127}));
  connect(pre_leak_vol.port_b, multiPort.port_a)
    annotation (Line(points={{-178,34},{-162,34}}, color={0,127,255}));
  connect(leak_resistor.port_b,leak_boundary. ports[1]) annotation (Line(points={{-87,16},
          {-68,16},{-68,34}},                    color={0,127,255}));
  connect(leak_resistor.port_a, pump.port_b)
    annotation (Line(points={{-101,16},{-101,14},{-120,14},{-120,16}},
                                                   color={0,127,255}));
  connect(pump.in_m_flow,LF_sample. y) annotation (Line(points={{-130,8.7},{
          -130,-10},{-175,-10}},
                               color={0,0,127}));
  connect(leak_resistor1.port_a, pump1.port_b)
    annotation (Line(points={{-85,30},{-102,30}}, color={0,127,255}));
  connect(leak_resistor1.port_b,leak_boundary. ports[2]) annotation (Line(
        points={{-71,30},{-68,30}},                   color={0,127,255}));
  connect(pump1.in_m_flow,LF_sample. y) annotation (Line(points={{-112,22.7},{
          -112,-10},{-175,-10}},
                               color={0,0,127}));
  connect(TCV3.port_b, pre_leak_vol.port_a) annotation (Line(points={{-206,34},
          {-206,32},{-190,32},{-190,34}}, color={0,127,255}));
  connect(multiPort.ports_b[1], massFlowRate_steam.port_a) annotation (Line(
        points={{-154,36.6667},{-144,36.6667},{-144,76},{-102,76}}, color={0,
          127,255}));
  connect(pump1.port_a, multiPort.ports_b[2]) annotation (Line(points={{-122,30},
          {-122,34},{-154,34}}, color={0,127,255}));
  connect(pump.port_a, multiPort.ports_b[3]) annotation (Line(points={{-140,16},
          {-144,16},{-144,34},{-154,34},{-154,31.3333}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-340,
            -120},{220,140}}), graphics={Bitmap(extent={{-344,-116},{202,164}},
            fileName="modelica://NEUP/../../BOP.png")}),         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-340,-120},{220,
            140}})));
end NuScaleBOP_fwp_and_leak;
