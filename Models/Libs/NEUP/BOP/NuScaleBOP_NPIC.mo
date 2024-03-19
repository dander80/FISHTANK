within NEUP.BOP;
model NuScaleBOP_NPIC
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-336,78},{-316,98}}),
        iconTransformation(extent={{-336,78},{-316,98}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_b(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-342,-68},{-322,-48}}),
        iconTransformation(extent={{-342,-68},{-322,-48}})));
  TRANSFORM.Fluid.Machines.SteamTurbine HPTurbine(redeclare package Medium =
        Modelica.Media.Water.StandardWater,
    p_a_start(displayUnit="MPa") = 3500000,
    p_b_start(displayUnit="MPa") = 1000000,
    use_T_start=false,
    h_a_start=3e6,
    m_flow_start=67,                        use_Stodola=false)
    annotation (Placement(transformation(extent={{-58,60},{-38,80}})));
  TRANSFORM.Fluid.Machines.SteamTurbine LPTurbine(redeclare package Medium =
        Modelica.Media.Water.StandardWater,
    p_a_start(displayUnit="MPa") = 1000000,
    p_b_start(displayUnit="kPa") = 10000,
    use_T_start=false,
    h_a_start=2.7e6,
    m_flow_start=(1 - 0.18)*67,             use_Stodola=false)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow Cond_Pump(redeclare package
      Medium = Modelica.Media.Water.StandardWater, m_flow_nominal=(1 - 0.18)*67)
    annotation (Placement(transformation(extent={{60,-96},{40,-76}})));
  TRANSFORM.Fluid.Volumes.IdealCondenser condenser(redeclare package Medium =
        Modelica.Media.Water.StandardWater, p(displayUnit="kPa") = 10000)
    annotation (Placement(transformation(extent={{80,-68},{100,-48}})));
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionVolume(redeclare package
      Medium = Modelica.Media.Water.StandardWater,
    p_start(displayUnit="MPa") = 1000000,
    use_T_start=false,
    h_start=2.7e6,
    V=1)
    annotation (Placement(transformation(extent={{16,86},{-4,66}})));
  TRANSFORM.Fluid.FittingsAndResistances.NominalLoss Bleed(redeclare package
      Medium = Modelica.Media.Water.StandardWater,
    dp_nominal(displayUnit="Pa") = 1e4,
    m_flow_nominal=0.18*67,
    p_nominal(displayUnit="Pa") = 1e6,
    T_nominal=726.15)                              annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={6,6})));
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
    annotation (Placement(transformation(extent={{-36,-96},{-16,-76}})));
  TRANSFORM.Electrical.PowerConverters.Generator generator
    annotation (Placement(transformation(extent={{98,60},{118,80}})));
  TRANSFORM.Electrical.Sources.FrequencySource
                            boundary
    annotation (Placement(transformation(extent={{208,60},{188,80}})));
  TRANSFORM.Electrical.Sensors.PowerSensor sensorW
    annotation (Placement(transformation(extent={{142,60},{162,80}})));
  NHES.Systems.PrimaryHeatSystem.SMR_Generic.Components.Data.Data_GenericModule
                                     data(length_steamGenerator_tube=36)
    annotation (Placement(transformation(extent={{86,84},{102,100}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow Cond_Pump1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=true,
    m_flow_nominal=67)
    annotation (Placement(transformation(extent={{-46,-96},{-66,-76}})));
  Modelica.Blocks.Interfaces.RealInput FW_Pump annotation (Placement(
        transformation(extent={{-12,-72},{-42,-42}}), iconTransformation(extent={{-15,-15},
            {15,15}},
        rotation=90,
        origin={115,-105})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate_fwp(redeclare package Medium =
        Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-124,-96},{-144,-76}})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate_steam(redeclare package
      Medium = Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-100,66},{-80,86}})));
  Modelica.Fluid.Sensors.Pressure pressure_Tvalve(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-132,76},{-112,96}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-290,66},{-270,86}})));
  Modelica.Blocks.Interfaces.RealInput T_valve1 annotation (Placement(
        transformation(extent={{-322,116},{-302,136}}), iconTransformation(
          extent={{14,-14},{-14,14}},
        rotation=90,
        origin={-278,120})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_start=100000,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-224,108},{-204,128}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV2(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-224,66},{-204,86}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV3(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-224,24},{-204,44}})));
  Modelica.Blocks.Sources.RealExpression Sensor_W(y=sensorW.y)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={208,-56})));
  Modelica.Blocks.Interfaces.RealOutput W_Sensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={208,-102}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-166,-110})));
  TRANSFORM.Fluid.Volumes.SimpleVolume pre_leak_vol(redeclare package Medium =
        Modelica.Media.Water.StandardWater, showName=false)
    annotation (Placement(transformation(extent={{-190,24},{-170,44}})));
  TRANSFORM.Fluid.BoundaryConditions.FixedBoundary leak_boundary(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T=673.15,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-56,34})));
  TRANSFORM.Fluid.FittingsAndResistances.NominalLoss leak_resistor1(showName=
        false, showDP=false)
    annotation (Placement(transformation(extent={{-86,22},{-66,42}})));
  Modelica.Blocks.Sources.TimeTable LF_profilev1(table=[0,0; 86400,0; 108000,0;
        109200,1.66667e-06; 130800,1.66667e-06; 132000,3.33333e-06; 150000,
        3.33333e-06; 150600,5e-06; 175800,5e-06; 176400,6.66667e-06; 280800,
        6.66667e-06; 282000,8.33333e-06; 303600,8.33333e-06; 304800,1e-05;
        363600,1e-05; 364200,1.16667e-05; 375000,1.16667e-05; 375600,
        1.33333e-05; 453600,1.33333e-05; 454800,1.5e-05; 476400,1.5e-05; 477600,
        1.66667e-05; 640800,1.66667e-05; 641400,1.83333e-05; 655800,1.83333e-05;
        656400,2e-05; 712800,2e-05; 714000,2.16667e-05; 735600,2.16667e-05;
        736800,2.33333e-05; 885600,2.33333e-05; 886800,2.5e-05; 908400,2.5e-05;
        909600,2.66667e-05; 975600,2.66667e-05; 976200,2.83333e-05; 994200,
        2.83333e-05; 994800,3e-05; 1058400,3e-05; 1059600,3.16667e-05; 1081200,
        3.16667e-05; 1082400,3.33333e-05; 1123200,3.33333e-05; 1209600,
        3.33333e-05])
    annotation (Placement(transformation(extent={{-9,-9},{9,9}},
        rotation=90,
        origin={-151,-9})));
  TRANSFORM.Fluid.FittingsAndResistances.MultiPort multiPort(redeclare package
      Medium = Modelica.Media.Water.StandardWater, nPorts_b=2)
    annotation (Placement(transformation(extent={{-160,24},{-152,44}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump1(use_input=true,
      m_flow_nominal=0.16)
    annotation (Placement(transformation(extent={{-120,42},{-100,22}})));
  Modelica.Fluid.Sensors.MassFlowRate TCV3_mdot(redeclare package Medium =
        Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-140,54},{-126,68}})));
  Modelica.Blocks.Sources.Constant no_leak(k=0) annotation (Placement(
        transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={-85,-9})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=3e-05,
    duration=1.2e6,
    offset=0,
    startTime=1000) annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={-117,-9})));
  Modelica.Blocks.Sources.Constant t_step(k=1.2e6)
    annotation (Placement(transformation(extent={{8,-8},{-8,8}},
        rotation=-90,
        origin={-266,-24})));
  Modelica.Blocks.Sources.ContinuousClock t(offset=0) annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-283,-7})));
  Modelica.Blocks.Sources.Constant min_Tvalve(k=0.95)
    annotation (Placement(transformation(extent={{8,-8},{-8,8}},
        rotation=-90,
        origin={-248,-6})));
  Extra_Equipment.decr_func decr_func
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-266,16})));
  Modelica.Blocks.Math.Product PID_prod annotation (Placement(transformation(
        extent={{-7,7},{7,-7}},
        rotation=0,
        origin={-249,49})));
  Modelica.Blocks.Sources.Constant no_mult(k=1)
    "use to prevent actuator degradation"
    annotation (Placement(transformation(extent={{8,-8},{-8,8}},
        rotation=180,
        origin={-292,44})));
equation
  connect(LPTurbine.shaft_a, HPTurbine.shaft_b)
    annotation (Line(points={{60,70},{-38,70}}, color={0,0,0}));
  connect(LPTurbine.shaft_b, generator.shaft)
    annotation (Line(points={{80,70},{98,70}}, color={0,0,0}));
  connect(generator.port, sensorW.port_a)
    annotation (Line(points={{118,70},{142,70}}, color={255,0,0}));
  connect(sensorW.port_b, boundary.port)
    annotation (Line(points={{162,70},{188,70}}, color={255,0,0}));
  connect(HPTurbine.portLP, teeJunctionVolume.port_2)
    annotation (Line(points={{-38,76},{-4,76}}, color={0,127,255}));
  connect(teeJunctionVolume.port_1, LPTurbine.portHP)
    annotation (Line(points={{16,76},{60,76}}, color={0,127,255}));
  connect(LPTurbine.portLP, condenser.port_a)
    annotation (Line(points={{80,76},{82,76},{82,-48},{84,-48},{84,-46},{83,-46},
          {83,-51}},                                    color={0,127,255}));
  connect(condenser.port_b, Cond_Pump.port_a) annotation (Line(points={{90,-66},
          {90,-86},{60,-86}},          color={0,127,255}));
  connect(Cond_Pump.port_b, OFWH.port_b[1]) annotation (Line(points={{40,-86},{
          10,-86},{10,-86.5},{-20,-86.5}},   color={0,127,255}));
  connect(teeJunctionVolume.port_3, Bleed.port_a) annotation (Line(points={{6,66},{
          6,13}},                      color={0,127,255}));
  connect(Bleed.port_b, OFWH.port_b[2]) annotation (Line(points={{6,-1},{6,
          -85.5},{-20,-85.5}},     color={0,127,255}));
  connect(Cond_Pump1.port_a, OFWH.port_a[1])
    annotation (Line(points={{-46,-86},{-32,-86}}, color={0,127,255}));
  connect(FW_Pump, Cond_Pump1.in_m_flow) annotation (Line(points={{-27,-57},{
          -41.5,-57},{-41.5,-78.7},{-56,-78.7}}, color={0,0,127}));
  connect(Cond_Pump1.port_b, massFlowRate_fwp.port_a) annotation (Line(points={{-66,-86},
          {-124,-86}},                               color={0,127,255}));
  connect(massFlowRate_fwp.port_b, port_b) annotation (Line(points={{-144,-86},
          {-318,-86},{-318,-58},{-332,-58}}, color={0,127,255}));
  connect(massFlowRate_steam.port_b, HPTurbine.portHP) annotation (Line(points={{-80,76},
          {-58,76}},                              color={0,127,255}));
  connect(pressure_Tvalve.port, massFlowRate_steam.port_a)
    annotation (Line(points={{-122,76},{-100,76}}, color={0,127,255}));
  connect(port_a, volume.port_a)
    annotation (Line(points={{-326,88},{-306,88},{-306,76},{-286,76}},
                                                   color={0,127,255}));
  connect(TCV2.port_a, volume.port_b)
    annotation (Line(points={{-224,76},{-274,76}}, color={0,127,255}));
  connect(TCV1.port_a, volume.port_b) annotation (Line(points={{-224,118},{-248,
          118},{-248,76},{-274,76}}, color={0,127,255}));
  connect(T_valve1, TCV1.opening)
    annotation (Line(points={{-312,126},{-214,126}}, color={0,0,127}));
  connect(T_valve1, TCV2.opening) annotation (Line(points={{-312,126},{-258,126},
          {-258,84},{-214,84}}, color={0,0,127}));
  connect(TCV2.port_b, pressure_Tvalve.port)
    annotation (Line(points={{-204,76},{-122,76}}, color={0,127,255}));
  connect(TCV1.port_b, pressure_Tvalve.port) annotation (Line(points={{-204,118},
          {-162,118},{-162,76},{-122,76}}, color={0,127,255}));
  connect(volume.port_b, TCV3.port_a) annotation (Line(points={{-274,76},{-248,
          76},{-248,34},{-224,34}}, color={0,127,255}));
  connect(Sensor_W.y, W_Sensor)
    annotation (Line(points={{208,-67},{208,-102}}, color={0,0,127}));
  connect(pre_leak_vol.port_b, multiPort.port_a)
    annotation (Line(points={{-174,34},{-160,34}}, color={0,127,255}));
  connect(leak_resistor1.port_a, pump1.port_b)
    annotation (Line(points={{-83,32},{-100,32}}, color={0,127,255}));
  connect(leak_resistor1.port_b,leak_boundary. ports[1]) annotation (Line(
        points={{-69,32},{-68,32},{-68,34},{-66,34}}, color={0,127,255}));
  connect(TCV3.port_b, pre_leak_vol.port_a) annotation (Line(points={{-204,34},
          {-186,34}},                     color={0,127,255}));
  connect(TCV3_mdot.port_b, pressure_Tvalve.port) annotation (Line(points={{-126,61},
          {-122,61},{-122,76}},          color={0,127,255}));
  connect(multiPort.ports_b[1], TCV3_mdot.port_a) annotation (Line(points={{-152,36},
          {-148,36},{-148,61},{-140,61}},          color={0,127,255}));
  connect(pump1.port_a, multiPort.ports_b[2]) annotation (Line(points={{-120,32},
          {-152,32}},                     color={0,127,255}));
  connect(t.y,decr_func. clock) annotation (Line(points={{-283,0.7},{-283,10},{
          -270.8,10}}, color={0,0,127}));
  connect(t_step.y,decr_func. time_step)
    annotation (Line(points={{-266,-15.2},{-266,7.8}},
                                                     color={0,0,127}));
  connect(min_Tvalve.y,decr_func. min_val) annotation (Line(points={{-248,2.8},
          {-248,10},{-261.2,10}},     color={0,0,127}));
  connect(TCV3.opening, PID_prod.y) annotation (Line(points={{-214,42},{-214,49},
          {-241.3,49}}, color={0,0,127}));
  connect(T_valve1, PID_prod.u2) annotation (Line(points={{-312,126},{-258,126},
          {-258,53.2},{-257.4,53.2}}, color={0,0,127}));
  connect(no_leak.y, pump1.in_m_flow) annotation (Line(points={{-85,0.9},{-85,
          16},{-110,16},{-110,24.7}}, color={0,0,127}));
  connect(no_mult.y, PID_prod.u1)
    annotation (Line(points={{-283.2,44},{-257.4,44.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-340,
            -120},{220,140}}), graphics={Bitmap(extent={{-344,-116},{202,164}},
            fileName="modelica://NEUP/../../BOP.png")}),         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-340,-120},{220,
            140}})));
end NuScaleBOP_NPIC;
