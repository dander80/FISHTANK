within NEUP.BOP;
model NuScaleBOP_NPIC_TBP
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-384,72},{-364,92}}),
        iconTransformation(extent={{-384,72},{-364,92}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_b(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-380,-74},{-360,-54}}),
        iconTransformation(extent={{-380,-74},{-360,-54}})));
  TRANSFORM.Fluid.Machines.SteamTurbine HPTurbine(redeclare package Medium =
        Modelica.Media.Water.StandardWater,
    p_a_start(displayUnit="MPa") = 3500000,
    p_b_start(displayUnit="MPa") = 1000000,
    use_T_start=false,
    h_a_start=3e6,
    m_flow_start=67,                        use_Stodola=false)
    annotation (Placement(transformation(extent={{4,62},{24,82}})));
  TRANSFORM.Fluid.Machines.SteamTurbine LPTurbine(redeclare package Medium =
        Modelica.Media.Water.StandardWater,
    p_a_start(displayUnit="MPa") = 1000000,
    p_b_start(displayUnit="kPa") = 10000,
    use_T_start=false,
    h_a_start=2.7e6,
    m_flow_start=(1 - 0.18)*67,             use_Stodola=false)
    annotation (Placement(transformation(extent={{122,62},{142,82}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow Cond_Pump(redeclare package
      Medium = Modelica.Media.Water.StandardWater, m_flow_nominal=(1 - 0.18)*67)
    annotation (Placement(transformation(extent={{110,-112},{90,-92}})));
  TRANSFORM.Fluid.Volumes.IdealCondenser condenser(redeclare package Medium =
        Modelica.Media.Water.StandardWater, p(displayUnit="kPa") = 10000)
    annotation (Placement(transformation(extent={{140,-96},{160,-76}})));
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionVolume(redeclare package
      Medium = Modelica.Media.Water.StandardWater,
    p_start(displayUnit="MPa") = 1000000,
    use_T_start=false,
    h_start=2.7e6,
    V=1)
    annotation (Placement(transformation(extent={{66,88},{46,68}})));
  TRANSFORM.Fluid.FittingsAndResistances.NominalLoss Bleed(redeclare package
      Medium = Modelica.Media.Water.StandardWater,
    dp_nominal(displayUnit="Pa") = 1e4,
    m_flow_nominal=0.18*67,
    p_nominal(displayUnit="Pa") = 1e6,
    T_nominal=726.15)                              annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={56,6})));
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
    annotation (Placement(transformation(extent={{26,-96},{46,-76}})));
  TRANSFORM.Electrical.PowerConverters.Generator generator
    annotation (Placement(transformation(extent={{160,62},{180,82}})));
  TRANSFORM.Electrical.Sources.FrequencySource
                            boundary
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={186,-6})));
  TRANSFORM.Electrical.Sensors.PowerSensor sensorW
    "total electrical power being generated"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={186,28})));
  NHES.Systems.PrimaryHeatSystem.SMR_Generic.Components.Data.Data_GenericModule
                                     data(length_steamGenerator_tube=36)
    annotation (Placement(transformation(extent={{148,86},{164,102}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow FWP(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_input=true,
    m_flow_nominal=67)
    annotation (Placement(transformation(extent={{16,-96},{-4,-76}})));
  Modelica.Blocks.Interfaces.RealInput FW_Pump annotation (Placement(
        transformation(extent={{50,-70},{20,-40}}),   iconTransformation(extent={{13,13},
            {-13,-13}},
        rotation=270,
        origin={121,-169})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate_fwp(redeclare package Medium =
        Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-126,-96},{-146,-76}})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate_steam(redeclare package
      Medium = Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-38,68},{-18,88}})));
  Modelica.Fluid.Sensors.Pressure pressure_Tvalve(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-106,78},{-86,98}})));
  Modelica.Blocks.Interfaces.RealInput TCV_inp annotation (Placement(
        transformation(extent={{-324,118},{-304,138}}), iconTransformation(
        extent={{12,-11},{-12,11}},
        rotation=180,
        origin={-381,144})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV1(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_start=100000,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-178,112},{-158,132}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV2(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-176,68},{-156,88}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TCV3(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=100000,
    m_flow_nominal=67,
    p_nominal=2768700)
    annotation (Placement(transformation(extent={{-178,28},{-158,48}})));
  Modelica.Blocks.Sources.RealExpression Sensor_W(y=sensorW.y)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={270,-54})));
  Modelica.Blocks.Interfaces.RealOutput W_Sensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={270,-100}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-470,324})));
  Modelica.Blocks.Interfaces.RealInput BV_inp annotation (Placement(
        transformation(extent={{-372,172},{-348,196}}), iconTransformation(
        extent={{13,13},{-13,-13}},
        rotation=180,
        origin={-385,-125})));
  TRANSFORM.Fluid.FittingsAndResistances.MultiPort multiPort1(redeclare package
      Medium = Modelica.Media.Water.StandardWater, nPorts_b=2)
    annotation (Placement(transformation(extent={{-6,-15},{6,15}},
        rotation=90,
        origin={147,-56})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume1(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-360,72},{-340,92}})));
  TRANSFORM.Fluid.Valves.ValveCompressible TBP(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_start=100000,
    dp_nominal=1900000,
    m_flow_nominal=30,
    p_nominal=3300000)
    annotation (Placement(transformation(extent={{-86,154},{-66,174}})));
  TRANSFORM.Fluid.FittingsAndResistances.MultiPort multiPort2(redeclare package
      Medium = Modelica.Media.Water.StandardWater, nPorts_b=4)
    annotation (Placement(transformation(extent={{-6,-15},{6,15}},
        rotation=0,
        origin={-319,82})));
equation
  connect(LPTurbine.shaft_a, HPTurbine.shaft_b)
    annotation (Line(points={{122,72},{24,72}}, color={0,0,0}));
  connect(LPTurbine.shaft_b, generator.shaft)
    annotation (Line(points={{142,72},{160,72}},
                                               color={0,0,0}));
  connect(generator.port, sensorW.port_a)
    annotation (Line(points={{180,72},{186,72},{186,38}},
                                                 color={255,0,0}));
  connect(sensorW.port_b, boundary.port)
    annotation (Line(points={{186,18},{186,4}},  color={255,0,0}));
  connect(HPTurbine.portLP, teeJunctionVolume.port_2)
    annotation (Line(points={{24,78},{46,78}},  color={0,127,255}));
  connect(teeJunctionVolume.port_1, LPTurbine.portHP)
    annotation (Line(points={{66,78},{122,78}},color={0,127,255}));
  connect(condenser.port_b, Cond_Pump.port_a) annotation (Line(points={{150,-94},
          {150,-102},{110,-102}},      color={0,127,255}));
  connect(Cond_Pump.port_b, OFWH.port_b[1]) annotation (Line(points={{90,-102},
          {56,-102},{56,-86.5},{42,-86.5}},  color={0,127,255}));
  connect(teeJunctionVolume.port_3, Bleed.port_a) annotation (Line(points={{56,68},
          {56,13}},                    color={0,127,255}));
  connect(Bleed.port_b, OFWH.port_b[2]) annotation (Line(points={{56,-1},{56,
          -85.5},{42,-85.5}},      color={0,127,255}));
  connect(FWP.port_a, OFWH.port_a[1])
    annotation (Line(points={{16,-86},{30,-86}}, color={0,127,255}));
  connect(FW_Pump, FWP.in_m_flow) annotation (Line(points={{35,-55},{20.5,-55},
          {20.5,-78.7},{6,-78.7}}, color={0,0,127}));
  connect(FWP.port_b, massFlowRate_fwp.port_a)
    annotation (Line(points={{-4,-86},{-126,-86}}, color={0,127,255}));
  connect(massFlowRate_fwp.port_b, port_b) annotation (Line(points={{-146,-86},
          {-320,-86},{-320,-64},{-370,-64}}, color={0,127,255}));
  connect(massFlowRate_steam.port_b, HPTurbine.portHP) annotation (Line(points={{-18,78},
          {4,78}},                                color={0,127,255}));
  connect(pressure_Tvalve.port, massFlowRate_steam.port_a)
    annotation (Line(points={{-96,78},{-38,78}},   color={0,127,255}));
  connect(TCV_inp, TCV1.opening) annotation (Line(points={{-314,128},{-210,128},
          {-210,130},{-168,130}}, color={0,0,127}));
  connect(TCV_inp, TCV2.opening) annotation (Line(points={{-314,128},{-212,128},
          {-212,86},{-166,86}}, color={0,0,127}));
  connect(TCV2.port_b, pressure_Tvalve.port)
    annotation (Line(points={{-156,78},{-96,78}},  color={0,127,255}));
  connect(TCV1.port_b, pressure_Tvalve.port) annotation (Line(points={{-158,122},
          {-116,122},{-116,78},{-96,78}},  color={0,127,255}));
  connect(Sensor_W.y, W_Sensor)
    annotation (Line(points={{270,-65},{270,-100}}, color={0,0,127}));
  connect(TCV3.port_b, pressure_Tvalve.port) annotation (Line(points={{-158,38},
          {-116,38},{-116,78},{-96,78}}, color={0,127,255}));
  connect(TCV_inp, TCV3.opening) annotation (Line(points={{-314,128},{-212,128},
          {-212,44},{-168,44},{-168,46}}, color={0,0,127}));
  connect(condenser.port_a, multiPort1.port_a) annotation (Line(points={{143,
          -79},{142,-79},{142,-66},{147,-66},{147,-62}}, color={0,127,255}));
  connect(multiPort1.ports_b[1], LPTurbine.portLP) annotation (Line(points={{
          144,-50},{146,-50},{146,-42},{150,-42},{150,78},{142,78}}, color={0,
          127,255}));
  connect(port_a, volume1.port_a)
    annotation (Line(points={{-374,82},{-356,82}}, color={0,127,255}));
  connect(TBP.opening, BV_inp) annotation (Line(points={{-76,172},{-76,184},{
          -360,184}}, color={0,0,127}));
  connect(TBP.port_b, multiPort1.ports_b[2]) annotation (Line(points={{-66,164},
          {230,164},{230,-46},{150,-46},{150,-50}}, color={0,127,255}));
  connect(volume1.port_b, multiPort2.port_a)
    annotation (Line(points={{-344,82},{-325,82}}, color={0,127,255}));
  connect(multiPort2.ports_b[1], TCV3.port_a) annotation (Line(points={{-313,
          86.5},{-312,86.5},{-312,78},{-222,78},{-222,38},{-178,38}}, color={0,
          127,255}));
  connect(multiPort2.ports_b[2], TCV2.port_a) annotation (Line(points={{-313,
          83.5},{-312,83.5},{-312,78},{-176,78}}, color={0,127,255}));
  connect(multiPort2.ports_b[3], TCV1.port_a) annotation (Line(points={{-313,
          80.5},{-222,80.5},{-222,122},{-178,122}}, color={0,127,255}));
  connect(TBP.port_a, multiPort2.ports_b[4]) annotation (Line(points={{-86,164},
          {-332,164},{-332,102},{-302,102},{-302,82},{-313,82}}, color={0,127,
          255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-400,
            -140},{300,240}}), graphics={Bitmap(extent={{-268,-134},{278,146}},
            fileName="modelica://NEUP/../../BOP.png")}),         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-400,-140},{300,
            240}})));
end NuScaleBOP_NPIC_TBP;
