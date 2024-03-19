within NEUP.FMUs;
model Plant_FMU_keeper
  Reactor.NuScaleModule_v5 nuScaleModule_v5_1(PressurizerandTopper(port_b(
          m_flow(start=-47439.42383434519))))
    annotation (Placement(transformation(extent={{-86,-52},{-42,-2}})));
  NHES.Systems.PrimaryHeatSystem.SMR_Generic.Components.Data.Data_GenericModule
                                     data(length_steamGenerator_tube=36)
    annotation (Placement(transformation(extent={{174,42},{190,58}})));
  Modelica.Blocks.Interfaces.RealInput Reactivity
    annotation (Placement(transformation(extent={{-194,68},{-154,108}})));
  Modelica.Blocks.Interfaces.RealInput FWP_input
    annotation (Placement(transformation(extent={{202,70},{170,102}}),
        iconTransformation(extent={{202,70},{170,102}})));
  Modelica.Blocks.Sources.Constant const(k=557.3)
    annotation (Placement(transformation(extent={{-180,-6},{-160,14}})));
  Modelica.Blocks.Sources.Constant const1(k=3.39e+06)
    annotation (Placement(transformation(extent={{98,42},{84,56}})));
  TRANSFORM.Controls.P_Control p_Control(k=0.005)
    annotation (Placement(transformation(extent={{-144,-6},{-124,14}})));
  Modelica.Blocks.Sources.TimeTable LF_profilev1(table=[0,1; 86400,1; 108000,
        1; 109200,0.8; 130800,0.8; 132000,1; 150000,1; 150600,0.9; 175800,0.9;
        176400,1; 280800,1; 282000,0.8; 303600,0.8; 304800,1; 363600,1;
        364200,0.9; 375000,0.9; 375600,1; 453600,1; 454800,0.8; 476400,0.8;
        477600,1; 640800,1; 641400,0.9; 655800,0.9; 656400,1; 712800,1;
        714000,0.8; 735600,0.8; 736800,1; 885600,1; 886800,0.8; 908400,0.8;
        909600,1; 975600,1; 976200,0.9; 994200,0.90; 994800,1; 1058400,1;
        1059600,0.80; 1081200,0.80; 1082400,1; 1123200,1; 1209600,1], nextEvent(
        start=86400.0))
    annotation (Placement(transformation(extent={{-140,-104},{-128,-92}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{8,8},{-8,-8}},
        rotation=90,
        origin={2,38})));
  Modelica.Blocks.Sources.ContinuousClock continuousClock(offset=0)
    annotation (Placement(transformation(extent={{7,-7},{-7,7}},
        rotation=90,
        origin={3,101})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=300)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=90,
        origin={2,76})));
  TRANSFORM.Controls.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    with_FF=false,
    k=-1,
    yb=1,
    k_s=1/const1.k,
    k_m=1/const1.k,
    yMax=1,
    yMin=0,
    I(y(start=-9.904558149828688E-14)))
            annotation (Placement(transformation(extent={{-8,-8},{8,8}},
        rotation=-90,
        origin={64,12})));
  Modelica.Blocks.Sources.Constant const3(k=1)
    annotation (Placement(transformation(extent={{-152,-82},{-140,-70}})));
  BOP_FMU_keeper BOP_mdot
    annotation (Placement(transformation(extent={{58,-62},{120,-10}})));
  TRANSFORM.Controls.LimPID PID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    with_FF=false,
    k=1,
    yb=53,
    k_s=1/FULL_PWR.k,
    k_m=1/FULL_PWR.k,
    yMax=53,
    yMin=18)
            annotation (Placement(transformation(extent={{-8,-8},{8,8}},
        rotation=0,
        origin={46,-90})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{8,-8},{-8,8}},
        rotation=180,
        origin={20,-114})));
  Modelica.Blocks.Sources.ContinuousClock continuousClock1(offset=0)
    annotation (Placement(transformation(extent={{7,-7},{-7,7}},
        rotation=180,
        origin={-63,-113})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=300)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=180,
        origin={-12,-114})));
  Modelica.Blocks.Sources.Constant FULL_PWR(k=4.147e7)
    annotation (Placement(transformation(extent={{-132,-146},{-112,-126}})));
  Modelica.Blocks.Math.Product product2
    annotation (Placement(transformation(extent={{-78,-98},{-62,-82}})));
  Modelica.Blocks.Math.Product FWD_multipier annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={100,-80})));
  Modelica.Blocks.Sources.Ramp FWP_ramp(
    height=-0.05,
    duration=1.2e6,
    offset=1,
    startTime=600)
    annotation (Placement(transformation(extent={{142,-110},{128,-96}})));
  Modelica.Blocks.Sources.Constant no_FWP(k=1)
    "use to prevent FWP degradation" annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={135,-133})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=nuScaleModule_v5_1.SG_press)
    annotation (Placement(transformation(extent={{150,-40},{170,-20}})));
  Modelica.Blocks.Interfaces.RealOutput SG_P
    annotation (Placement(transformation(extent={{192,-40},{212,-20}})));
equation
  connect(p_Control.y, nuScaleModule_v5_1.CR_reactivity) annotation (Line(
        points={{-123,4},{-102,4},{-102,-10},{-71.15,-10},{-71.15,-12}},
                                                              color={0,0,127}));
  connect(nuScaleModule_v5_1.Core_Tavg, p_Control.u_m) annotation (Line(
        points={{-70.7375,-16.4231},{-70.7375,-18},{-134,-18},{-134,-8}},
                                                                       color=
          {0,0,127}));
  connect(const.y, p_Control.u_s) annotation (Line(points={{-159,4},{-146,4}},
                                color={0,0,127}));
  connect(continuousClock.y, lessThreshold.u) annotation (Line(points={{3,93.3},
          {2,93.3},{2,83.2}},                      color={0,0,127}));
  connect(lessThreshold.y, switch1.u2)
    annotation (Line(points={{2,69.4},{0,69.4},{0,70},{2,70},{2,47.6}},
                                                     color={255,0,255}));
  connect(switch1.y, PID.u_m) annotation (Line(points={{2,29.2},{2,12},{54.4,
          12}},                 color={0,0,127}));
  connect(const1.y, PID.u_s) annotation (Line(points={{83.3,49},{64,49},{64,
          21.6}},                 color={0,0,127}));
  connect(nuScaleModule_v5_1.port_a, BOP_mdot.port_a) annotation (Line(points={{
          -51.4875,-20.2692},{-51.4875,-20},{2,-20},{2,-18.32},{59.2765,-18.32}},
        color={0,127,255}));
  connect(nuScaleModule_v5_1.port_b, BOP_mdot.port_b) annotation (Line(points={{
          -51.4875,-50.2692},{-51.4875,-50},{58.7294,-50},{58.7294,-52.64}},
        color={0,127,255}));
  connect(PID.y, BOP_mdot.T_valve1) annotation (Line(points={{64,3.2},{64,-8},{
          63.6529,-8},{63.6529,-20.4}},color={0,0,127}));
  connect(continuousClock1.y, lessThreshold1.u)
    annotation (Line(points={{-55.3,-113},{-19.2,-114}},color={0,0,127}));
  connect(switch2.u2, lessThreshold1.y)
    annotation (Line(points={{10.4,-114},{-5.4,-114}}, color={255,0,255}));
  connect(switch2.y, PID1.u_m) annotation (Line(points={{28.8,-114},{46,-114},
          {46,-99.6}}, color={0,0,127}));
  connect(product2.y, PID1.u_s)
    annotation (Line(points={{-61.2,-90},{36.4,-90}}, color={0,0,127}));
  connect(product2.u2, FULL_PWR.y) annotation (Line(points={{-79.6,-94.8},{
          -92,-94.8},{-92,-136},{-111,-136}},color={0,0,127}));
  connect(switch2.u3, BOP_mdot.W_Sensor) annotation (Line(points={{10.4,-107.6},
          {10.4,-108},{6,-108},{6,-50.3},{73.8647,-50.3}},
                                                       color={0,0,127}));
  connect(switch2.u1, FULL_PWR.y) annotation (Line(points={{10.4,-120.4},{
          10.4,-136},{-111,-136}},color={0,0,127}));
  connect(switch1.u1, const1.y) annotation (Line(points={{8.4,47.6},{64,47.6},
          {64,49},{83.3,49}}, color={0,0,127}));
  connect(switch1.u3, nuScaleModule_v5_1.SG_press) annotation (Line(points={{
          -4.4,47.6},{-54.5125,47.6},{-54.5125,-8.73077}}, color={0,0,127}));
  connect(BOP_mdot.FW_Pump, FWD_multipier.y)
    annotation (Line(points={{99.4853,-49.65},{100,-71.2}},
                                                         color={0,0,127}));
  connect(PID1.y, FWD_multipier.u1) annotation (Line(points={{54.8,-90},{94,-90},
          {94,-89.6},{95.2,-89.6}},       color={0,0,127}));
  connect(no_FWP.y, FWD_multipier.u2) annotation (Line(points={{127.3,-133},{
          104.8,-133},{104.8,-89.6}}, color={0,0,127}));
  connect(const3.y, product2.u1) annotation (Line(points={{-139.4,-76},{-78,
          -76},{-78,-82},{-79.6,-82},{-79.6,-85.2}}, color={0,0,127}));
  connect(realExpression2.y, SG_P)
    annotation (Line(points={{171,-30},{202,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -160},{220,120}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,
            120}})),
    experiment(
      StopTime=1210000,
      Interval=100,
      Tolerance=1e-05,
      __Dymola_Algorithm="Esdirk45a"));
end Plant_FMU_keeper;
