within NEUP.BOP;
model NuScaleBOP_w_bypass
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-242,24},{-222,44}}),
        iconTransformation(extent={{-242,24},{-222,44}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_b(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-244,-62},{-224,-42}}),
        iconTransformation(extent={{-244,-62},{-224,-42}})));
  TRANSFORM.Fluid.Machines.SteamTurbine HPTurbine(redeclare package Medium =
        Modelica.Media.Water.StandardWater,
    p_a_start(displayUnit="MPa") = 3500000,
    p_b_start(displayUnit="MPa") = 1000000,
    use_T_start=false,
    h_a_start=3e6,
    m_flow_start=67,                        use_Stodola=false)
    annotation (Placement(transformation(extent={{36,6},{56,26}})));
  TRANSFORM.Fluid.Machines.SteamTurbine LPTurbine(redeclare package Medium =
        Modelica.Media.Water.StandardWater,
    p_a_start(displayUnit="MPa") = 1000000,
    p_b_start(displayUnit="kPa") = 10000,
    use_T_start=false,
    h_a_start=2.7e6,
    m_flow_start=(1 - 0.18)*67,             use_Stodola=false)
    annotation (Placement(transformation(extent={{154,6},{174,26}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow Cond_Pump(redeclare package
      Medium = Modelica.Media.Water.StandardWater, m_flow_nominal=(1 - 0.18)*67)
    annotation (Placement(transformation(extent={{118,-152},{98,-132}})));
  TRANSFORM.Fluid.Volumes.IdealCondenser condenser(redeclare package Medium =
        Modelica.Media.Water.StandardWater, p(displayUnit="kPa") = 10000)
    annotation (Placement(transformation(extent={{172,-152},{192,-132}})));
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionVolume(redeclare package
      Medium = Modelica.Media.Water.StandardWater,
    p_start(displayUnit="MPa") = 1000000,
    use_T_start=false,
    h_start=2.7e6,
    V=1)
    annotation (Placement(transformation(extent={{110,32},{90,12}})));
  TRANSFORM.Fluid.FittingsAndResistances.NominalLoss Bleed(redeclare package
      Medium = Modelica.Media.Water.StandardWater,
    dp_nominal(displayUnit="Pa") = 1e4,
    m_flow_nominal=0.18*67,
    p_nominal(displayUnit="Pa") = 1e6,
    T_nominal=726.15)                              annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={108,-48})));
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
    annotation (Placement(transformation(extent={{58,-152},{78,-132}})));
  TRANSFORM.Electrical.PowerConverters.Generator generator
    annotation (Placement(transformation(extent={{192,6},{212,26}})));
  TRANSFORM.Electrical.Sources.FrequencySource
                            boundary
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={212,-60})));
  TRANSFORM.Electrical.Sensors.PowerSensor sensorW
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={212,-18})));
  NHES.Systems.PrimaryHeatSystem.SMR_Generic.Components.Data.Data_GenericModule
                                     data(length_steamGenerator_tube=36)
    annotation (Placement(transformation(extent={{180,30},{196,46}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow Cond_Pump1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=true,
    m_flow_nominal=67)
    annotation (Placement(transformation(extent={{48,-152},{28,-132}})));
  Modelica.Blocks.Interfaces.RealInput FW_Pump annotation (Placement(
        transformation(extent={{82,-126},{52,-96}}),  iconTransformation(extent={{15,-15},
            {-15,15}},
        rotation=90,
        origin={115,-105})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate_fwp(redeclare package Medium =
        Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-30,-150},{-50,-130}})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate_steam(redeclare package
      Medium = Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-6,12},{14,32}})));
  Modelica.Fluid.Sensors.Pressure pressure_Tvalve(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-38,22},{-18,42}})));
  Modelica.Blocks.Interfaces.RealInput T_valve1 annotation (Placement(
        transformation(extent={{-174,70},{-154,90}}),   iconTransformation(
          extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-290,130})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_start=100000,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-112,54},{-92,74}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV2(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-112,12},{-92,32}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV3(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-112,-30},{-92,-10}})));
  Modelica.Blocks.Sources.RealExpression Sensor_W(y=sensorW.y)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={270,-70})));
  Modelica.Blocks.Interfaces.RealOutput W_Sensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={270,-116}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-166,-110})));
  TRANSFORM.Fluid.FittingsAndResistances.MultiPort multiPort(nPorts_b=4)
    annotation (Placement(transformation(extent={{-198,16},{-184,50}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TBP(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_start=100000,
    dp_nominal=1900000,
    m_flow_nominal=30,
    p_nominal=3300000)
    annotation (Placement(transformation(extent={{-96,112},{-76,132}})));
  TRANSFORM.Fluid.FittingsAndResistances.MultiPort multiPort1(nPorts_b=2)
    annotation (Placement(transformation(
        extent={{-7,-17},{7,17}},
        rotation=90,
        origin={175,-117})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume2(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-224,24},{-204,44}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    duration=0.5e6,
    offset=1,
    startTime=300)
    annotation (Placement(transformation(extent={{-50,150},{-64,164}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{8,-8},{-8,8}},
        rotation=90,
        origin={-86,148})));
  Modelica.Blocks.Sources.ContinuousClock continuousClock(offset=0)
    annotation (Placement(transformation(extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-85,211})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=300)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=90,
        origin={-86,186})));
  Modelica.Blocks.Sources.Constant const3(k=1)
    annotation (Placement(transformation(extent={{-120,152},{-108,164}})));
equation
  connect(LPTurbine.shaft_a, HPTurbine.shaft_b)
    annotation (Line(points={{154,16},{56,16}}, color={0,0,0}));
  connect(LPTurbine.shaft_b, generator.shaft)
    annotation (Line(points={{174,16},{192,16}},
                                               color={0,0,0}));
  connect(generator.port, sensorW.port_a)
    annotation (Line(points={{212,16},{212,-8}}, color={255,0,0}));
  connect(sensorW.port_b, boundary.port)
    annotation (Line(points={{212,-28},{212,-50}},
                                                 color={255,0,0}));
  connect(HPTurbine.portLP, teeJunctionVolume.port_2)
    annotation (Line(points={{56,22},{90,22}},  color={0,127,255}));
  connect(teeJunctionVolume.port_1, LPTurbine.portHP)
    annotation (Line(points={{110,22},{154,22}},
                                               color={0,127,255}));
  connect(condenser.port_b, Cond_Pump.port_a) annotation (Line(points={{182,
          -150},{152,-150},{152,-142},{118,-142}},
                                       color={0,127,255}));
  connect(Cond_Pump.port_b, OFWH.port_b[1]) annotation (Line(points={{98,-142},
          {86,-142},{86,-142.5},{74,-142.5}},color={0,127,255}));
  connect(teeJunctionVolume.port_3, Bleed.port_a) annotation (Line(points={{100,12},
          {100,-30},{108,-30},{108,-41}},
                                       color={0,127,255}));
  connect(Bleed.port_b, OFWH.port_b[2]) annotation (Line(points={{108,-55},{90,
          -55},{90,-141.5},{74,-141.5}},
                                   color={0,127,255}));
  connect(Cond_Pump1.port_a, OFWH.port_a[1])
    annotation (Line(points={{48,-142},{62,-142}}, color={0,127,255}));
  connect(FW_Pump, Cond_Pump1.in_m_flow) annotation (Line(points={{67,-111},{
          52.5,-111},{52.5,-134.7},{38,-134.7}}, color={0,0,127}));
  connect(Cond_Pump1.port_b, massFlowRate_fwp.port_a) annotation (Line(points={{28,-142},
          {-2,-142},{-2,-140},{-30,-140}},           color={0,127,255}));
  connect(massFlowRate_fwp.port_b, port_b) annotation (Line(points={{-50,-140},
          {-232,-140},{-232,-52},{-234,-52}},color={0,127,255}));
  connect(massFlowRate_steam.port_b, HPTurbine.portHP) annotation (Line(points={{14,22},
          {36,22}},                               color={0,127,255}));
  connect(pressure_Tvalve.port, massFlowRate_steam.port_a)
    annotation (Line(points={{-28,22},{-6,22}},    color={0,127,255}));
  connect(T_valve1, TCV1.opening)
    annotation (Line(points={{-164,80},{-102,80},{-102,72}},
                                                     color={0,0,127}));
  connect(T_valve1, TCV2.opening) annotation (Line(points={{-164,80},{-146,80},
          {-146,38},{-102,38},{-102,30}},
                                color={0,0,127}));
  connect(T_valve1, TCV3.opening) annotation (Line(points={{-164,80},{-146,80},
          {-146,38},{-116,38},{-116,-4},{-102,-4},{-102,-12}},
                                color={0,0,127}));
  connect(TCV2.port_b, pressure_Tvalve.port)
    annotation (Line(points={{-92,22},{-28,22}},   color={0,127,255}));
  connect(TCV1.port_b, pressure_Tvalve.port) annotation (Line(points={{-92,64},
          {-50,64},{-50,22},{-28,22}},     color={0,127,255}));
  connect(TCV3.port_b, pressure_Tvalve.port) annotation (Line(points={{-92,-20},
          {-50,-20},{-50,22},{-28,22}},   color={0,127,255}));
  connect(Sensor_W.y, W_Sensor)
    annotation (Line(points={{270,-81},{270,-116}}, color={0,0,127}));
  connect(multiPort1.ports_b[1], LPTurbine.portLP) annotation (Line(points={{
          171.6,-110},{174,-110},{174,4},{176,4},{176,18},{174,18},{174,22}},
        color={0,127,255}));
  connect(condenser.port_a, multiPort1.port_a) annotation (Line(points={{175,
          -135},{174,-135},{174,-128},{175,-128},{175,-124}}, color={0,127,255}));
  connect(multiPort1.ports_b[2], TBP.port_b) annotation (Line(points={{178.4,
          -110},{180,-110},{180,-94},{122,-94},{122,122},{-76,122}}, color={0,
          127,255}));
  connect(port_a, volume2.port_a)
    annotation (Line(points={{-232,34},{-220,34}}, color={0,127,255}));
  connect(multiPort.port_a, volume2.port_b) annotation (Line(points={{-198,33},
          {-198,32},{-208,32},{-208,34}}, color={0,127,255}));
  connect(lessThreshold.y,switch1. u2)
    annotation (Line(points={{-86,179.4},{-88,179.4},{-88,180},{-86,180},{-86,
          157.6}},                                   color={255,0,255}));
  connect(continuousClock.y, lessThreshold.u) annotation (Line(points={{-85,
          203.3},{-86,203.3},{-86,193.2}}, color={0,0,127}));
  connect(switch1.y, TBP.opening)
    annotation (Line(points={{-86,139.2},{-86,130}}, color={0,0,127}));
  connect(const3.y, switch1.u1) annotation (Line(points={{-107.4,158},{-100,158},
          {-100,157.6},{-92.4,157.6}}, color={0,0,127}));
  connect(switch1.u3, ramp.y) annotation (Line(points={{-79.6,157.6},{-64.7,
          157.6},{-64.7,157}}, color={0,0,127}));
  connect(TBP.port_a, multiPort.ports_b[1]) annotation (Line(points={{-96,122},
          {-184,122},{-184,38.1}}, color={0,127,255}));
  connect(TCV3.port_a, multiPort.ports_b[2]) annotation (Line(points={{-112,-20},
          {-176,-20},{-176,56},{-184,56},{-184,34.7}}, color={0,127,255}));
  connect(TCV2.port_a, multiPort.ports_b[3]) annotation (Line(points={{-112,22},
          {-176,22},{-176,56},{-184,56},{-184,31.3}}, color={0,127,255}));
  connect(TCV1.port_a, multiPort.ports_b[4]) annotation (Line(points={{-112,64},
          {-184,64},{-184,27.9}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-300,
            -200},{300,240}}), graphics={Bitmap(extent={{-344,-116},{202,164}},
            fileName="modelica://NEUP/../../BOP.png")}),         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-300,-200},{300,
            240}})));
end NuScaleBOP_w_bypass;
