within NEUP.Reactor;
model NuScaleModule_v3_duplicate
  import       Modelica.Units.SI;
  package Medium = Modelica.Media.Water.StandardWater;
  package Medium_PHTS = Modelica.Media.Water.StandardWater;
  Modelica.Fluid.Pipes.DynamicPipe Lower_Riser(
    crossArea=2.313,
    isCircular=true,
    diameter=1.716,
    p_a_start=system.p_ambient,
    allowFlowReversal=true,
    use_HeatTransfer=false,
    p_b_start=system.p_ambient,
    length=2.865,
    height_ab=2.865,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.DetailedPipeFlow,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T_start=data.T_hot)       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,-52})));
  Modelica.Fluid.Pipes.DynamicPipe DownComer(
    crossArea=2.388,
    isCircular=true,
    diameter=1.744,
    p_a_start=system.p_ambient,
    p_b_start=system.p_ambient,
    length=8.521,
    height_ab=-8.521,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T_start(displayUnit="K") = data.T_cold)
                              annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={34,-50})));
  Modelica.Fluid.Pipes.DynamicPipe Upper_Riser(
    crossArea=1.431,
    isCircular=true,
    diameter=1.35,
    p_a_start=system.p_ambient,
    length=7.925,
    height_ab=7.925,
    p_b_start=system.p_ambient,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T_start=data.T_hot)       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,-18})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium =
        Modelica.Media.Water.StandardWater, allowFlowReversal=true)
    annotation (Placement(transformation(extent={{-6,-112},{-22,-96}})));
  Modelica.Fluid.Sensors.Temperature Tcore_exit(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-82,-72},{-94,-60}})));
  Modelica.Fluid.Pipes.DynamicPipe PressurizerandTopper(
    crossArea=1.431,
    isCircular=true,
    diameter=1.35,
    p_a_start=system.p_ambient,
    p_b_start=system.p_ambient,
    length=0.823,
    height_ab=0.823,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    T_start=data.T_hot)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,16})));
  Modelica.Fluid.Sensors.Temperature Tcore_inlet(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-80,-106},{-94,-118}})));
  TRANSFORM.Fluid.FittingsAndResistances.PipeLoss pipeLoss(
    allowFlowReversal=true,
    m_flow_start=100,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance.Circle
        (dimension_avg=0.4),
    K_ab=635.0) annotation (Placement(transformation(extent={{-2,28},{18,48}})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX STHX(
    exposeState_b_shell=true,
    exposeState_b_tube=true,
    redeclare package Material_tubeWall = TRANSFORM.Media.Solids.SS304,
    redeclare model HeatTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Alphas_TwoPhase_3Region,
    p_a_start_shell=data.p,
    T_a_start_shell=data.T_hot,
    T_b_start_shell=data.T_cold,
    m_flow_a_start_shell=data.m_flow,
    p_a_start_tube=data.p_steam,
    use_Ts_start_tube=false,
    h_a_start_tube=data.h_steam_cold,
    h_b_start_tube=data.h_steam_hot,
    m_flow_a_start_tube=data.m_flow,
    ps_start_shell=dataInitial.p_start_STHX_shell,
    Ts_start_shell=dataInitial.T_start_STHX_shell,
    ps_start_tube=dataInitial.p_start_STHX_tube,
    hs_start_tube=dataInitial.h_start_STHX_tube,
    Ts_wall_start=dataInitial.T_start_STHX_tubeWall,
    redeclare package Medium_tube = Modelica.Media.Water.StandardWater,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_i_shell=data.d_steamGenerator_shell_inner,
        D_o_shell=data.d_steamGenerator_shell_outer,
        length_shell=data.length_steamGenerator,
        nTubes=data.nTubes_steamGenerator,
        nV=10,
        dimension_tube=data.d_steamGenerator_tube_inner,
        length_tube=data.length_steamGenerator_tube,
        th_wall=data.th_steamGenerator_tube,
        nR=2,
        angle_shell=-1.5707963267949),
    redeclare model HeatTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare package Medium_shell = Modelica.Media.Water.StandardWater)
                                                                  annotation (Placement(transformation(
        extent={{-12,-11},{12,11}},
        rotation=90,
        origin={39,2})));

  Modelica.Fluid.Sensors.Temperature temperature2(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{52,-36},{68,-50}})));
  Modelica.Fluid.Sensors.Temperature temperature3(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{46,54},{62,40}})));
  TRANSFORM.Fluid.Volumes.ExpansionTank_1Port pressurizer(
    p_start=dataInitial.p_start_pressurizer,
    h_start=dataInitial.h_start_pressurizer,
    A=0.25*Modelica.Constants.pi*data.d_pressurizer^2,
    level_start=dataInitial.level_start_pressurizer,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    "pressurizer.Medium.bubbleEnthalpy(Medium.setSat_p(pressurizer.p_start))"
    annotation (Placement(transformation(extent={{-42,72},{-22,92}})));
  TRANSFORM.Fluid.FittingsAndResistances.TeeJunctionVolume pressurizer_tee(
    V=0.001,
    p_start=dataInitial.p_start_pressurizer_tee,
    T_start=dataInitial.T_start_pressurizer_tee,
    redeclare package Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-38,32},{-26,44}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance teeTopressurizer(R=1,
      redeclare package Medium = Modelica.Media.Water.StandardWater)
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-32,58})));
  TRANSFORM.Nuclear.CoreSubchannels.Regions_3 core(
    redeclare package Material_2 = TRANSFORM.Media.Solids.Helium,
    redeclare package Material_3 = TRANSFORM.Media.Solids.ZrNb_E125,
    nParallel=data.nAssembly,
    p_b_start(displayUnit="Pa"),
    Q_nominal=data.Q_total,
    SigmaF_start=26,
    T_start_1=data.T_avg + 400,
    T_start_2=data.T_avg + 130,
    T_start_3=data.T_avg + 30,
    p_a_start(displayUnit="Pa") = data.p,
    T_a_start(displayUnit="K") = data.T_cold,
    T_b_start(displayUnit="K") = data.T_hot,
    m_flow_a_start=data.m_flow,
    exposeState_a=false,
    exposeState_b=false,
    Ts_start(displayUnit="degC") = dataInitial.T_start_core_coolantSubchannel,
    ps_start=dataInitial.p_start_core_coolantSubchannel,
    Ts_start_1(displayUnit="K") = dataInitial.Ts_start_core_fuelModel_region_1,
    Ts_start_2(displayUnit="K") = dataInitial.Ts_start_core_fuelModel_region_2,
    Ts_start_3(displayUnit="K") = dataInitial.Ts_start_core_fuelModel_region_3,
    fissionProductDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare record Data_DH =
        TRANSFORM.Nuclear.ReactorKinetics.Data.DecayHeat.decayHeat_11_TRACEdefault,
    redeclare record Data_FP =
        TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_H3TeIXe_U235,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    redeclare model Geometry =
        TRANSFORM.Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Assembly
        (
        nPins=data.nRodFuel_assembly,
        nPins_nonFuel=data.nRodNonFuel_assembly,
        width_FtoF_inner=data.sizeAssembly*data.pitch_fuelRod,
        rs_outer={data.r_pellet_fuelRod,data.r_pellet_fuelRod + data.th_gap_fuelRod,
            data.r_outer_fuelRod},
        length=data.length_core,
        angle=1.5707963267949),
    redeclare package Material_1 = TRANSFORM.Media.Solids.UO2,
    rho_input=CR_reactivity,
    Teffref_fuel=764.206,
    Teffref_coolant=565.392)
                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-64,-88})));

  Modelica.Fluid.Sensors.MassFlowRate massFlowRate1(redeclare package Medium =
        Modelica.Media.Water.StandardWater, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{62,-80},{44,-62}})));
  Modelica.Fluid.Sensors.Pressure Secondary_Side_Pressure(redeclare package
      Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{82,62},{102,82}})));
  Modelica.Fluid.Sensors.SpecificEnthalpy Steam_exit_enthalpy(redeclare package
      Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{30,58},{48,76}})));
  Modelica.Fluid.Sensors.SpecificEnthalpy Feed_Enthalpy(redeclare package
      Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{58,-24},{76,-6}})));
  NHES.Systems.PrimaryHeatSystem.SMR_Generic.Components.Data.Data_GenericModule
                                     data(length_steamGenerator_tube=36)
    annotation (Placement(transformation(extent={{64,96},{80,112}})));
  NHES.Systems.PrimaryHeatSystem.SMR_Generic.Components.Data.DataInitial
                              dataInitial(p_start_pressurizer=12755300)
    annotation (Placement(transformation(extent={{82,94},{102,114}})));
  Modelica.Blocks.Interfaces.RealInput CR_reactivity
    annotation (Placement(transformation(extent={{-164,-52},{-124,-12}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph Outlet(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p(displayUnit="MPa") = data.p_steam,
    h=data.h_steam_hot,
    nPorts=1) annotation (Placement(transformation(extent={{134,24},{114,44}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph      Inlet(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=data.p_steam,
    h=data.h_steam_cold,
    nPorts=1)
    annotation (Placement(transformation(extent={{136,-92},{116,-72}})));
  inner Modelica.Fluid.System system(
    T_ambient(displayUnit="K") = 531.48,
    p_ambient(displayUnit="bar") = 12755300,
    m_flow_start=100)
    annotation (Placement(transformation(extent={{-94,70},{-74,90}})));
  TRANSFORM.Fluid.Machines.Pump_SimpleMassFlow pump(redeclare package Medium =
        Modelica.Media.Water.StandardWater,
    use_input=false,                        m_flow_nominal=data.m_flow_steam)
    annotation (Placement(transformation(extent={{92,-82},{72,-62}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=core.Q_total.y)
    annotation (Placement(transformation(extent={{136,-44},{156,-24}})));
  Modelica.Blocks.Interfaces.RealOutput Q_Total
    annotation (Placement(transformation(extent={{182,-44},{202,-24}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=Steam_exit_enthalpy.h_out)
    annotation (Placement(transformation(extent={{126,66},{146,86}})));
  Modelica.Blocks.Interfaces.RealOutput Core_Tavg annotation (Placement(
        transformation(extent={{-224,-68},{-206,-50}}), iconTransformation(
          extent={{-224,-68},{-206,-50}})));
  Modelica.Blocks.Interfaces.RealOutput SG_outlet_Enthalpy
    annotation (Placement(transformation(extent={{158,66},{178,86}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=AvgCore_T.y)
    annotation (Placement(transformation(extent={{-270,-68},{-250,-48}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-114,-94},{-134,-74}})));
  Modelica.Blocks.Math.Gain AvgCore_T(k=0.5)
    annotation (Placement(transformation(extent={{-158,-94},{-178,-74}})));
  Modelica.Blocks.Interfaces.RealOutput SG_outlet_Temp
    annotation (Placement(transformation(extent={{160,42},{180,62}})));
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{196,-100},{156,-60}})));
equation
  connect(Lower_Riser.port_b,Upper_Riser. port_a)
    annotation (Line(points={{-64,-42},{-64,-28}},
                                                 color={0,127,255}));
  connect(Upper_Riser.port_b,PressurizerandTopper. port_a)
    annotation (Line(points={{-64,-8},{-64,6}},  color={0,127,255}));
  connect(DownComer.port_b,massFlowRate. port_a)
    annotation (Line(points={{34,-60},{34,-104},{-6,-104}},
                                                         color={0,127,255}));
  connect(DownComer.port_a,STHX. port_b_shell)
    annotation (Line(points={{34,-40},{34,-10},{33.94,-10}},
                                                           color={0,127,255}));
  connect(pipeLoss.port_b,STHX. port_a_shell) annotation (Line(points={{18,38},{
          33.94,38},{33.94,14}},  color={0,127,255}));
  connect(temperature2.port,STHX. port_a_tube) annotation (Line(points={{60,-36},
          {62,-36},{62,-32},{48,-32},{48,-10},{39,-10}},
                                                     color={0,127,255}));
  connect(temperature3.port,STHX. port_b_tube)
    annotation (Line(points={{54,54},{39,54},{39,14}}, color={0,127,255}));
  connect(PressurizerandTopper.port_b,pressurizer_tee. port_1)
    annotation (Line(points={{-64,26},{-64,38},{-38,38}}, color={0,127,255}));
  connect(pressurizer_tee.port_2,pipeLoss. port_a)
    annotation (Line(points={{-26,38},{-2,38}}, color={0,127,255}));
  connect(teeTopressurizer.port_b,pressurizer. port)
    annotation (Line(points={{-32,65},{-32,73.6}}, color={0,127,255}));
  connect(pressurizer_tee.port_3,teeTopressurizer. port_a)
    annotation (Line(points={{-32,44},{-32,51}}, color={0,127,255}));
  connect(core.port_b,Lower_Riser. port_a)
    annotation (Line(points={{-64,-78},{-64,-62}}, color={0,127,255}));
  connect(massFlowRate.port_b,core. port_a) annotation (Line(points={{-22,-104},
          {-64,-104},{-64,-98}},color={0,127,255}));
  connect(massFlowRate1.port_b,STHX. port_a_tube)
    annotation (Line(points={{44,-71},{39,-71},{39,-10}},color={0,127,255}));
  connect(Tcore_inlet.port,core. port_a) annotation (Line(points={{-87,-106},{-88,
          -106},{-88,-102},{-64,-102},{-64,-98}},   color={0,127,255}));
  connect(Tcore_exit.port,Lower_Riser. port_a) annotation (Line(points={{-88,-72},
          {-64,-72},{-64,-62}}, color={0,127,255}));
  connect(STHX.port_b_tube,Secondary_Side_Pressure. port) annotation (Line(
        points={{39,14},{39,22},{86,22},{86,62},{92,62}},color={0,127,255}));
  connect(STHX.port_b_tube,Steam_exit_enthalpy. port)
    annotation (Line(points={{39,14},{39,58}}, color={0,127,255}));
  connect(STHX.port_a_tube,Feed_Enthalpy. port) annotation (Line(points={{39,-10},
          {52,-10},{52,-24},{67,-24}},      color={0,127,255}));
  connect(Outlet.ports[1], STHX.port_b_tube) annotation (Line(points={{114,34},
          {76,34},{76,14},{39,14}}, color={0,127,255}));
  connect(Inlet.ports[1], pump.port_a) annotation (Line(points={{116,-82},{98,
          -82},{98,-71},{92,-72}}, color={0,127,255}));
  connect(pump.port_b, massFlowRate1.port_a) annotation (Line(points={{72,-72},
          {67,-72},{67,-71},{62,-71}}, color={0,127,255}));
  connect(realExpression.y, Q_Total)
    annotation (Line(points={{157,-34},{192,-34}}, color={0,0,127}));
  connect(realExpression2.y, SG_outlet_Enthalpy)
    annotation (Line(points={{147,76},{168,76}}, color={0,0,127}));
  connect(add.u1, Tcore_exit.T) annotation (Line(points={{-112,-78},{-102,-78},
          {-102,-66},{-92.2,-66}}, color={0,0,127}));
  connect(add.u2, Tcore_inlet.T) annotation (Line(points={{-112,-90},{-102,-90},
          {-102,-112},{-91.9,-112}}, color={0,0,127}));
  connect(add.y, AvgCore_T.u)
    annotation (Line(points={{-135,-84},{-156,-84}}, color={0,0,127}));
  connect(realExpression1.y, Core_Tavg) annotation (Line(points={{-249,-58},{
          -236,-58},{-236,-59},{-215,-59}}, color={0,0,127}));
  connect(temperature3.T, SG_outlet_Temp) annotation (Line(points={{59.6,47},{
          63.8,47},{63.8,52},{170,52}}, color={0,0,127}));
  connect(u, pump.in_m_flow) annotation (Line(points={{176,-80},{130,-80},{130,
          -64.7},{82,-64.7}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000, __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end NuScaleModule_v3_duplicate;
