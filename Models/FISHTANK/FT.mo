within FISHTANK;
model FT "Show the treatment of empty tanks"
  extends Modelica.Icons.Example;
  Modelica.Fluid.Vessels.OpenTank tank1(
    redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    nPorts=3,
    crossArea=0.1824,
    level_start=0.15,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=
        0.038, height=0),Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(
        diameter=0.038, height=0.1),
        Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.038,
        height=0.76)},
    height=0.76)
                annotation (Placement(transformation(extent={{-140,0},{-100,40}})));

  Modelica.Fluid.Pipes.StaticPipe pipe_t1_to_res(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    length=0.15,
    diameter=0.038,
    height_ab=-0.15) annotation (Placement(transformation(
        origin={-126,-40},
        extent={{-10,-10},{10,10}},
        rotation=270)));

  Modelica.Fluid.Vessels.OpenTank res_tank(
    crossArea=1.21,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    nPorts=3,
    height=0.45,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=
        0.038, height=1.1),Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(
        diameter=0.038, height=1.1),
        Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.06,
        height=0)},
    level_start=0.3)
    annotation (Placement(transformation(extent={{-40,-94},{0,-54}})));

  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                                   annotation (Placement(transformation(
          extent={{142,116},{162,136}})));
  Modelica.Fluid.Vessels.OpenTank tank2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    nPorts=3,
    crossArea=0.1824,
    level_start=0.15,
    portsData={Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=
        0.038, height=0),Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(
        diameter=0.038, height=0.1),
        Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter=0.038,
        height=0.76)},
    height=0.76)
                annotation (Placement(transformation(extent={{100,0},{140,40}})));

  Modelica.Fluid.Pipes.StaticPipe pipe_t2_to_res(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    length=0.15,
    diameter=0.038,
    height_ab=-0.15) annotation (Placement(transformation(
        origin={116,-40},
        extent={{-10,-10},{10,10}},
        rotation=270)));

  Modelica.Fluid.Pipes.StaticPipe pipe_btw_tanks(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    length=1,
    diameter=0.038,
    height_ab=0) annotation (Placement(transformation(extent={{-16,-28},{-36,-8}},
          rotation=0)));

  TRANSFORM.Fluid.Machines.Pump            sump_pump(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_start=2,
    checkValve=true,
    m_flow_nominal=2)   annotation (Placement(visible=true, transformation(
        origin={20,-68},
        extent={{-10,-10},{10,10}},
        rotation=90)));

  Modelica.Fluid.Fittings.MultiPort multiPort(nPorts_b=2) annotation (Placement(
        transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={20,62})));
  Modelica.Fluid.Pipes.StaticPipe pipe_pump_to_multiport(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    length=1.8,
    diameter=0.038,
    height_ab=1.8) annotation (Placement(transformation(
        origin={20,-34},
        extent={{10,-10},{-10,10}},
        rotation=270)));

  Modelica.Fluid.Pipes.StaticPipe pipe_multi_to_t1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    length=0.5,
    diameter=0.038,
    height_ab=0) annotation (Placement(transformation(extent={{-14,56},{-34,76}},
          rotation=0)));

  Modelica.Fluid.Pipes.StaticPipe pipe_multi_to_t2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    length=0.5,
    diameter=0.038,
    height_ab=0) annotation (Placement(transformation(extent={{32,56},{52,76}},
          rotation=0)));

  Modelica.Fluid.Pipes.StaticPipe pipe_CV1_to_t1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    length=0.15,
    diameter=0.038,
    height_ab=-0.15) annotation (Placement(transformation(
        origin={-80,30},
        extent={{-10,10},{10,-10}},
        rotation=270)));

  Modelica.Fluid.Pipes.StaticPipe pipe_CV1_to_t2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    length=0.15,
    diameter=0.038,
    height_ab=-0.15) annotation (Placement(transformation(
        origin={162,20},
        extent={{-10,10},{10,-10}},
        rotation=270)));

  TRANSFORM.Fluid.Valves.ValveIncompressible CV1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_start=sump_pump.m_flow_nominal/2,
    m_flow_small=1e-10,
    dp_nominal=10000,
    m_flow_nominal=sump_pump.m_flow_nominal/2) annotation (Placement(visible=true,
        transformation(
        origin={-54,66},
        extent={{10,-10},{-10,10}},
        rotation=0)));

  TRANSFORM.Fluid.Valves.ValveIncompressible CV2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    m_flow_start=sump_pump.m_flow_nominal/2,
    m_flow_small=1e-10,
    dp_nominal=10000,
    m_flow_nominal=sump_pump.m_flow_nominal/2) annotation (Placement(visible=true,
        transformation(
        origin={68,66},
        extent={{10,10},{-10,-10}},
        rotation=180)));

  TRANSFORM.Fluid.Sensors.MassFlowRate sensor_mdot_pump annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,22})));
  TRANSFORM.Fluid.Sensors.MassFlowRate sensor_m_flow1 annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-80,2})));
  TRANSFORM.Fluid.Sensors.MassFlowRate sensor_m_flow2 annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={162,-6})));
  Modelica.Blocks.Interfaces.RealInput cv_pos_1 annotation (Placement(
        transformation(extent={{-140,70},{-120,90}}), iconTransformation(extent=
           {{-140,70},{-120,90}})));
  Modelica.Blocks.Interfaces.RealInput cv_pos_2 annotation (Placement(
        transformation(extent={{-150,84},{-130,104}}), iconTransformation(
          extent={{140,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput mdot_pump annotation (Placement(
        transformation(extent={{-2,12},{18,32}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealOutput mdot_t1 annotation (Placement(
        transformation(extent={{-146,54},{-126,74}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-140,-110})));
  Modelica.Blocks.Interfaces.RealOutput mdot_t2 annotation (Placement(
        transformation(extent={{178,66},{198,86}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={140,-110})));
  Modelica.Blocks.Interfaces.RealOutput t1_level annotation (Placement(
        transformation(extent={{-158,118},{-178,138}}),
                                                      iconTransformation(extent={{-158,
            118},{-178,138}})));
  Modelica.Blocks.Sources.RealExpression LT1(y=tank1.level)
    annotation (Placement(transformation(extent={{-128,118},{-148,138}})));
  Modelica.Blocks.Sources.RealExpression LT2(y=tank2.level)
    annotation (Placement(transformation(extent={{184,118},{204,138}})));
  Modelica.Blocks.Interfaces.RealOutput t2_level annotation (Placement(
        transformation(extent={{224,120},{244,140}}),
                                                    iconTransformation(extent={{224,120},
            {244,140}})));
  TRANSFORM.Fluid.Valves.ValveIncompressible reduction_1(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,

    m_flow_start=sump_pump.m_flow_nominal/2,
    m_flow_small=1e-10,
    dp_nominal=10000,
    m_flow_nominal=sump_pump.m_flow_nominal/2,
    opening_nominal=0.5) annotation (Placement(visible=true, transformation(
        origin={-126,-74},
        extent={{10,-10},{-10,10}},
        rotation=90)));

  TRANSFORM.Fluid.Valves.ValveIncompressible reduction_2(
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,

    m_flow_start=sump_pump.m_flow_nominal/2,
    m_flow_small=1e-10,
    dp_nominal=10000,
    m_flow_nominal=sump_pump.m_flow_nominal/2,
    opening_nominal=0.5) annotation (Placement(visible=true, transformation(
        origin={116,-74},
        extent={{10,10},{-10,-10}},
        rotation=90)));

  Modelica.Blocks.Sources.Constant tank1_Setpoint(k=0.45)
    annotation (Placement(transformation(extent={{-86,-160},{-66,-140}})));
equation
  connect(tank1.ports[1], pipe_t1_to_res.port_a) annotation (Line(points={{
          -125.333,0},{-126,0},{-126,-30}}, color={0,127,255}));

  connect(tank2.ports[1], pipe_t2_to_res.port_a) annotation (Line(points={{114.667,
          0},{116,0},{116,-30}},         color={0,127,255}));
  connect(pipe_btw_tanks.port_b, tank1.ports[2]) annotation (Line(points={{-36,-18},
          {-120,-18},{-120,0}},      color={0,127,255}));
  connect(pipe_btw_tanks.port_a, tank2.ports[2])
    annotation (Line(points={{-16,-18},{120,-18},{120,0}}, color={0,127,255}));
  connect(res_tank.ports[1], sump_pump.port_a) annotation (Line(points={{
          -25.3333,-94},{-14,-94},{-14,-98},{4,-98},{4,-96},{20,-96},{20,-78}},
        color={0,127,255}));
  connect(sump_pump.port_b, pipe_pump_to_multiport.port_a)
    annotation (Line(points={{20,-58},{20,-44}}, color={0,127,255}));
  connect(multiPort.ports_b[1], pipe_multi_to_t2.port_a)
    annotation (Line(points={{18,66},{32,66}}, color={0,127,255}));
  connect(multiPort.ports_b[2], pipe_multi_to_t1.port_a)
    annotation (Line(points={{22,66},{-14,66}}, color={0,127,255}));
  connect(pipe_multi_to_t1.port_b, CV1.port_a)
    annotation (Line(points={{-34,66},{-44,66}}, color={0,127,255}));
  connect(CV1.port_b, pipe_CV1_to_t1.port_a)
    annotation (Line(points={{-64,66},{-80,66},{-80,40}}, color={0,127,255}));
  connect(pipe_multi_to_t2.port_b, CV2.port_a)
    annotation (Line(points={{52,66},{58,66}}, color={0,127,255}));
  connect(CV2.port_b, pipe_CV1_to_t2.port_a) annotation (Line(points={{78,66},{
          118,66},{118,42},{162,42},{162,30}},
                                           color={0,127,255}));
  connect(multiPort.port_a, sensor_mdot_pump.port_b)
    annotation (Line(points={{20,58},{20,32}}, color={0,127,255}));
  connect(sensor_mdot_pump.port_a, pipe_pump_to_multiport.port_b)
    annotation (Line(points={{20,12},{20,-24}}, color={0,127,255}));
  connect(pipe_CV1_to_t1.port_b, sensor_m_flow1.port_a)
    annotation (Line(points={{-80,20},{-80,12}}, color={0,127,255}));
  connect(sensor_m_flow1.port_b, tank1.ports[3]) annotation (Line(points={{-80,-8},
          {-80,-12},{-114.667,-12},{-114.667,0}},     color={0,127,255}));
  connect(pipe_CV1_to_t2.port_b, sensor_m_flow2.port_a)
    annotation (Line(points={{162,10},{162,4}},color={0,127,255}));
  connect(sensor_m_flow2.port_b, tank2.ports[3]) annotation (Line(points={{162,-16},
          {162,-22},{116,-22},{116,0},{125.333,0}},color={0,127,255}));
  connect(cv_pos_1, CV1.opening) annotation (Line(points={{-130,80},{-82,80},{
          -82,80},{-54,80},{-54,74}}, color={0,0,127}));
  connect(cv_pos_2, CV2.opening) annotation (Line(points={{-140,94},{-140,92},{
          68,92},{68,74}}, color={0,0,127}));
  connect(sensor_mdot_pump.m_flow, mdot_pump)
    annotation (Line(points={{16.4,22},{8,22}}, color={0,0,127}));
  connect(sensor_m_flow1.m_flow, mdot_t1) annotation (Line(points={{-83.6,2},{
          -96,2},{-96,64},{-136,64}}, color={0,0,127}));
  connect(sensor_m_flow2.m_flow, mdot_t2) annotation (Line(points={{165.6,-6},{
          178,-6},{178,60},{172,60},{172,76},{188,76}},
                                color={0,0,127}));
  connect(t1_level, t1_level)
    annotation (Line(points={{-168,128},{-168,128}},
                                                   color={0,0,127}));
  connect(LT1.y, t1_level)
    annotation (Line(points={{-149,128},{-168,128}},
                                                   color={0,0,127}));
  connect(t2_level, t2_level)
    annotation (Line(points={{234,130},{234,130}},
                                                 color={0,0,127}));
  connect(LT2.y, t2_level) annotation (Line(points={{205,128},{220,128},{220,
          130},{234,130}},
                     color={0,0,127}));
  connect(pipe_t1_to_res.port_b, reduction_1.port_a) annotation (Line(points={{
          -126,-50},{-126,-54},{-124,-54},{-124,-64},{-126,-64}}, color={0,127,
          255}));
  connect(reduction_1.port_b, res_tank.ports[2]) annotation (Line(points={{-126,
          -84},{-126,-100},{-20,-100},{-20,-94}}, color={0,127,255}));
  connect(pipe_t2_to_res.port_b, reduction_2.port_a)
    annotation (Line(points={{116,-50},{116,-64}}, color={0,127,255}));
  connect(reduction_2.port_b, res_tank.ports[3]) annotation (Line(points={{116,
          -84},{116,-96},{4,-96},{4,-98},{-14,-98},{-14,-94},{-14.6667,-94}},
        color={0,127,255}));
  connect(tank1_Setpoint.y, reduction_1.opening) annotation (Line(points={{-65,
          -150},{-65,-120},{-134,-120},{-134,-74}}, color={0,0,127}));
  connect(tank1_Setpoint.y, reduction_2.opening) annotation (Line(points={{-65,
          -150},{-65,-120},{134,-120},{134,-74},{124,-74}}, color={0,0,127}));
  annotation (
    experiment(StopTime=80, __Dymola_Algorithm="Esdirk45a"),
    __Dymola_Commands(file="modelica://Modelica/Resources/Scripts/Dymola/Fluid/EmptyTanks/plot level and port.p.mos"
        "plot level and port.p"),
    Documentation(info="<html>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Examples/Tanks/EmptyTanks.png\" border=\"1\"
     alt=\"EmptyTanks.png\">
</html>"),
    Diagram(coordinateSystem(extent={{-180,-140},{180,140}})),
    Icon(coordinateSystem(extent={{-180,-140},{180,140}})));
end FT;
