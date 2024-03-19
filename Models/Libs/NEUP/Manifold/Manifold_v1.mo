within NEUP.Manifold;
model Manifold_v1
  import       Modelica.Units.SI;
  package Medium = Modelica.Media.Water.StandardWater;
  package Medium_PHTS = Modelica.Media.Water.StandardWater;
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance(R=1,
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-86,36},{-66,56}})));
  TRANSFORM.Fluid.Volumes.MixingVolume steamHeader(
    use_T_start=false,
    nPorts_a=1,
    nPorts_b=1 + nPorts_b3,
    redeclare package Medium = Medium,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
        (V=20),
    p_start=port_a1_start.p,
    h_start=port_a1_start.h)
    annotation (Placement(transformation(extent={{-56,36},{-36,56}})));
  TRANSFORM.Fluid.Valves.ValveIncompressible valve_b2(
    rho_nominal=Medium_1.density_ph(port_a1_nominal.p, port_a1_nominal.h),
    redeclare package Medium = Medium,
    m_flow_nominal=port_a1_nominal.m_flow,
    dp_nominal=dp_nominal_valve_b2)
    annotation (Placement(transformation(extent={{24,36},{44,56}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_b2(
    redeclare package Medium = Medium,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=diameter_b2,
        length=length_b2,
        nV=2),
    exposeState_b=true,
    use_Ts_start=false,
    h_a_start=port_a1_start.h,
    h_b_start=port_a1_start.h,
    p_a_start=port_a1_start.p - valve_b2.dp_start,
    m_flow_a_start=-port_b2_start.m_flow)
    annotation (Placement(transformation(extent={{54,36},{74,56}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_a2(
    redeclare package Medium = Medium,
    exposeState_b=true,
    use_Ts_start=false,
    p_a_start=port_a2_start.p,
    h_a_start=port_a2_start.h,
    h_b_start=port_a2_start.h,
    m_flow_a_start=port_a2_start.m_flow,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=2,
        dimension=diameter_a2,
        length=length_a2))
    annotation (Placement(transformation(extent={{4,-44},{-16,-24}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph source_b3[nPorts_b3](
    redeclare package Medium = Medium,
    each nPorts=1,
    each use_p_in=true,
    each use_h_in=true) if nPorts_b3 > 0 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-66,-74})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_b3[
    nPorts_b3](redeclare package Medium = Medium, each R=1)
                                                  if nPorts_b3 > 0 and use_pipeDelay_b3
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-36,-74})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_b3[nPorts_b3](
    redeclare package Medium = Medium,
    each exposeState_b=true,
    h_a_start=fill(port_a1_start.h, nPorts_b3),
    h_b_start=fill(port_a1_start.h, nPorts_b3),
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        each nV=2,
        dimension=diameter_b3,
        length=length_b3),
    m_flow_a_start=-port_b3_start_m_flow,
    each use_Ts_start=false,
    p_a_start={port_a1_start.p for i in 1:nPorts_b3})
                             if nPorts_b3 > 0 and use_pipeDelay_b3 annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-6,-74})));
  TRANSFORM.Fluid.Sensors.MassFlowRate massFlowRate_b3[nPorts_b3](redeclare
      package Medium = Medium) if nPorts_b3 > 0
    annotation (Placement(transformation(extent={{14,-84},{34,-64}})));
  TRANSFORM.Fluid.Sensors.SpecificEnthalpyTwoPort specificEnthalpy_b3_return[
    nPorts_b3](redeclare package Medium = Medium)
                                        if nPorts_b3 > 0
    annotation (Placement(transformation(extent={{44,-84},{64,-64}})));
  Modelica.Blocks.Sources.RealExpression pressure_steamHeader[nPorts_b3](each y=
        steamHeader.medium.p) if nPorts_b3 > 0
    annotation (Placement(transformation(extent={{-126,-70},{-106,-50}})));
  Modelica.Blocks.Sources.RealExpression specificEnthalpy_steamHeader[nPorts_b3](each y=
        steamHeader.medium.h) if nPorts_b3 > 0
    annotation (Placement(transformation(extent={{-126,-84},{-106,-64}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_h sink_b3[nPorts_b3](
    redeclare package Medium = Medium,
    each nPorts=1,
    each use_m_flow_in=true,
    each use_h_in=true) if nPorts_b3 > 0 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-8,6})));
  Modelica.Blocks.Math.Gain gain[nPorts_b3](each k=-1) if nPorts_b3 > 0
    annotation (Placement(transformation(extent={{14,-6},{6,2}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        NHES.Systems.EnergyManifold.SteamManifold.BaseClasses.Record_SubSystem_C.Medium_1,
      m_flow(min=if allowFlowReversal then -Constants.inf else 0))
    "Fluid connector a (positive design flow direction is from port_a_1 to port_b_1)"
    annotation (Placement(transformation(extent={{-116,36},{-96,56}}),
        iconTransformation(extent={{-110,30},{-90,50}})));
   Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        NHES.Systems.EnergyManifold.SteamManifold.BaseClasses.Record_SubSystem_C.Medium_1,
      m_flow(max=if allowFlowReversal then +Constants.inf else 0))
     "Fluid connector b (positive design flow direction is from port_a_1 to port_b_1)"
     annotation (Placement(transformation(extent={{-116,-44},{-96,-24}}),
         iconTransformation(extent={{-110,-50},{-90,-30}})));
   Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium =
        NHES.Systems.EnergyManifold.SteamManifold.BaseClasses.Record_SubSystem_C.Medium_2,
      m_flow(min=if allowFlowReversal then -Constants.inf else 0))
     "Fluid connector a (positive design flow direction is from port_a_2 to port_b_2)"
     annotation (Placement(transformation(extent={{84,-44},{104,-24}}),
         iconTransformation(extent={{90,-50},{110,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium =
        NHES.Systems.EnergyManifold.SteamManifold.BaseClasses.Record_SubSystem_C.Medium_2,
      m_flow(max=if allowFlowReversal then +Constants.inf else 0))
    "Fluid connector b (positive design flow direction is from port_a_2 to port_b_2)"
    annotation (Placement(transformation(extent={{84,36},{104,56}}),
        iconTransformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b3[nPorts_b3](redeclare package
      Medium =
        NHES.Systems.EnergyManifold.SteamManifold.BaseClasses.Record_SubSystem_C.Medium_3,
      m_flow(each max=if allowFlowReversal then +Constants.inf else 0))
    "Fluid connector b (positive design flow direction is from port_a_3 to port_b_3)"
    annotation (Placement(transformation(extent={{24,-104},{44,-84}}),
        iconTransformation(extent={{30,-110},{50,-90}})));
equation
  connect(port_a1,resistance. port_a)
    annotation (Line(points={{-106,46},{-83,46}}, color={0,127,255}));
  connect(resistance.port_b,steamHeader. port_a[1])
    annotation (Line(points={{-69,46},{-52,46}}, color={0,127,255}));
  connect(steamHeader.port_b[1],valve_b2. port_a)
    annotation (Line(points={{-40,46},{24,46}}, color={0,127,255}));
  connect(pressure_steamHeader.y,source_b3. p_in) annotation (Line(points={{-105,
          -60},{-96,-60},{-96,-66},{-78,-66}}, color={0,0,127}));
  connect(specificEnthalpy_steamHeader.y,source_b3. h_in) annotation (Line(
        points={{-105,-74},{-96,-74},{-96,-70},{-78,-70}},color={0,0,127}));
  connect(massFlowRate_b3.m_flow,gain. u)
    annotation (Line(points={{24,-70.4},{24,-2},{14.8,-2}},
                                                          color={0,0,127}));
  connect(gain.y,sink_b3. m_flow_in)
    annotation (Line(points={{5.6,-2},{2,-2}},  color={0,0,127}));
  connect(specificEnthalpy_b3_return.h_out,sink_b3. h_in)
    annotation (Line(points={{54,-70.4},{54,2},{4,2}},  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
                              Text(
          extent={{-20,-86},{10,-92}},
          lineColor={0,0,0},
          textString="Conditionally connected
based on exterior connections")}));
end Manifold_v1;
