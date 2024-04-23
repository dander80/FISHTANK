within NEUP;
package PowerPlant_Models

  model PowerPlant_leak
    Reactor.NuScaleModule_v5 nuScaleModule_v5_1
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
      annotation (Placement(transformation(extent={{-180,8},{-160,28}})));
    Modelica.Blocks.Sources.Constant const1(k=3.39e+06)
      annotation (Placement(transformation(extent={{98,40},{84,54}})));
    TRANSFORM.Controls.P_Control p_Control(k=0.005)
      annotation (Placement(transformation(extent={{-144,8},{-124,28}})));
    Modelica.Blocks.Sources.TimeTable LF_sample(table=[0,1; 86400,1; 108000,1;
          108900,0.8; 130500,0.8; 131400,1; 194400,1; 195300,0.8; 216900,0.8;
          217800,1; 280800,1; 281700,0.8; 303300,0.8; 304200,1; 367200,1;
          368100,0.8; 389700,0.8; 390600,1; 518400,1])
      annotation (Placement(transformation(extent={{-92,-90},{-80,-78}})));
    Modelica.Blocks.Sources.TimeTable LF_profilev1(table=[0,1; 86400,1; 108000,
          1; 109200,0.8; 130800,0.8; 132000,1; 150000,1; 150600,0.9; 175800,0.9;
          176400,1; 280800,1; 282000,0.8; 303600,0.8; 304800,1; 363600,1;
          364200,0.9; 375000,0.9; 375600,1; 453600,1; 454800,0.8; 476400,0.8;
          477600,1; 640800,1; 641400,0.90; 655800,0.90; 656400,1; 712800,1;
          714000,0.80; 735600,0.80; 736800,1; 885600,1; 886800,0.80; 908400,
          0.80; 909600,1; 975600,1; 976200,0.9; 994200,0.90; 994800,1; 1058400,
          1; 1059600,0.80; 1081200,0.80; 1082400,1; 1123200,1; 1209600,1])
      annotation (Placement(transformation(extent={{-76,-104},{-64,-92}})));
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
      yMin=0) annotation (Placement(transformation(extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={64,12})));
    Modelica.Blocks.Sources.Constant const3(k=1)
      annotation (Placement(transformation(extent={{-108,-72},{-96,-60}})));
    BOP.NuScaleBOP_leak    BOP_mdot
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
          origin={92,-80})));
    Modelica.Blocks.Logical.Switch switch2
      annotation (Placement(transformation(extent={{8,8},{-8,-8}},
          rotation=180,
          origin={64,-104})));
    Modelica.Blocks.Sources.ContinuousClock continuousClock1(offset=0)
      annotation (Placement(transformation(extent={{7,-7},{-7,7}},
          rotation=180,
          origin={-19,-103})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=300)
      annotation (Placement(transformation(extent={{6,-6},{-6,6}},
          rotation=180,
          origin={32,-104})));
    Modelica.Blocks.Sources.Constant FULL_PWR(k=4.147e7)
      annotation (Placement(transformation(extent={{-88,-136},{-68,-116}})));
    Modelica.Blocks.Math.Product product2
      annotation (Placement(transformation(extent={{-34,-88},{-18,-72}})));
  equation
    connect(p_Control.y, nuScaleModule_v5_1.CR_reactivity) annotation (Line(
          points={{-123,18},{-70,18},{-70,-8},{-71.15,-8},{-71.15,-12}},
                                                                color={0,0,127}));
    connect(nuScaleModule_v5_1.Core_Tavg, p_Control.u_m) annotation (Line(
          points={{-70.7375,-16.4231},{-134,-16.4231},{-134,6}},         color=
            {0,0,127}));
    connect(const.y, p_Control.u_s) annotation (Line(points={{-159,18},{-146,18}},
                                  color={0,0,127}));
    connect(continuousClock.y, lessThreshold.u) annotation (Line(points={{3,93.3},
            {2,93.3},{2,83.2}},                      color={0,0,127}));
    connect(lessThreshold.y, switch1.u2)
      annotation (Line(points={{2,69.4},{0,69.4},{0,70},{2,70},{2,47.6}},
                                                       color={255,0,255}));
    connect(switch1.y, PID.u_m) annotation (Line(points={{2,29.2},{2,12},{54.4,
            12}},                 color={0,0,127}));
    connect(const1.y, PID.u_s) annotation (Line(points={{83.3,47},{64,47},{64,
            21.6}},                 color={0,0,127}));
    connect(nuScaleModule_v5_1.port_a, BOP_mdot.port_a) annotation (Line(points={{
            -51.4875,-20.2692},{-51.4875,-20},{2,-20},{2,-20.4},{59.3286,-20.4}},
          color={0,127,255}));
    connect(nuScaleModule_v5_1.port_b, BOP_mdot.port_b) annotation (Line(points={{
            -51.4875,-50.2692},{-51.4875,-38},{59.1071,-38},{59.1071,-37.6}},
          color={0,127,255}));
    connect(PID.y, BOP_mdot.T_valve1) annotation (Line(points={{64,3.2},{64,-8},
            {63.5357,-8},{63.5357,-12}}, color={0,0,127}));
    connect(continuousClock1.y, lessThreshold1.u)
      annotation (Line(points={{-11.3,-103},{24.8,-104}}, color={0,0,127}));
    connect(switch2.u2, lessThreshold1.y)
      annotation (Line(points={{54.4,-104},{38.6,-104}}, color={255,0,255}));
    connect(switch2.y, PID1.u_m) annotation (Line(points={{72.8,-104},{92,-104},
            {92,-89.6}}, color={0,0,127}));
    connect(PID1.y, BOP_mdot.FW_Pump) annotation (Line(points={{100.8,-80},{108,
            -80},{108,-68},{108.375,-68},{108.375,-59}}, color={0,0,127}));
    connect(product2.y, PID1.u_s)
      annotation (Line(points={{-17.2,-80},{82.4,-80}}, color={0,0,127}));
    connect(product2.u2, FULL_PWR.y) annotation (Line(points={{-35.6,-84.8},{
            -50,-84.8},{-50,-126},{-67,-126}}, color={0,0,127}));
    connect(LF_profilev1.y, product2.u1) annotation (Line(points={{-63.4,-98},{
            -52,-98},{-52,-75.2},{-35.6,-75.2}}, color={0,0,127}));
    connect(const1.y, switch1.u1)
      annotation (Line(points={{83.3,47},{8.4,47.6}}, color={0,0,127}));
    connect(switch1.u3, nuScaleModule_v5_1.SG_press) annotation (Line(points={{
            -4.4,47.6},{-54.5125,47.6},{-54.5125,-8.73077}}, color={0,0,127}));
    connect(FULL_PWR.y, switch2.u3) annotation (Line(points={{-67,-126},{-50,
            -126},{-50,-120},{54.4,-120},{54.4,-110.4}}, color={0,0,127}));
    connect(switch2.u1, BOP_mdot.W_Sensor) annotation (Line(points={{54.4,-97.6},
            {54.4,-68},{76,-68},{76,-64},{77.2643,-64},{77.2643,-60}}, color={0,
            0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
              -160},{220,120}})),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,
              120}})),
      experiment(
        StopTime=1210000,
        Interval=100,
        Tolerance=1e-05,
        __Dymola_Algorithm="Esdirk45a"));
  end PowerPlant_leak;

  model PowerPlant_actuator
    Reactor.NuScaleModule_v5 nuScaleModule_v5_1
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
      annotation (Placement(transformation(extent={{-180,8},{-160,28}})));
    Modelica.Blocks.Sources.Constant const1(k=3.39e+06)
      annotation (Placement(transformation(extent={{98,42},{84,56}})));
    TRANSFORM.Controls.P_Control p_Control(k=0.005)
      annotation (Placement(transformation(extent={{-144,8},{-124,28}})));
    Modelica.Blocks.Sources.TimeTable LF_sample(table=[0,1; 86400,1; 108000,1;
          108900,0.8; 130500,0.8; 131400,1; 194400,1; 195300,0.8; 216900,0.8;
          217800,1; 280800,1; 281700,0.8; 303300,0.8; 304200,1; 367200,1;
          368100,0.8; 389700,0.8; 390600,1; 518400,1])
      annotation (Placement(transformation(extent={{-92,-90},{-80,-78}})));
    Modelica.Blocks.Sources.TimeTable LF_profilev1(table=[0,1; 86400,1; 108000,
          1; 109200,0.8; 130800,0.8; 132000,1; 150000,1; 150600,0.9; 175800,0.9;
          176400,1; 280800,1; 282000,0.8; 303600,0.8; 304800,1; 363600,1;
          364200,0.9; 375000,0.9; 375600,1; 453600,1; 454800,0.8; 476400,0.8;
          477600,1; 640800,1; 641400,0.9; 655800,0.9; 656400,1; 712800,1;
          714000,0.8; 735600,0.8; 736800,1; 885600,1; 886800,0.8; 908400,0.8;
          909600,1; 975600,1; 976200,0.9; 994200,0.9; 994800,1; 1058400,1;
          1059600,0.8; 1081200,0.8; 1082400,1; 1123200,1; 1209600,1])
      annotation (Placement(transformation(extent={{-76,-104},{-64,-92}})));
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
      yMin=0) annotation (Placement(transformation(extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={64,12})));
    Modelica.Blocks.Sources.Constant const3(k=1)
      annotation (Placement(transformation(extent={{-108,-72},{-96,-60}})));
    BOP.NuScaleBOP_actuator BOP_mdot
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
          origin={92,-80})));
    Modelica.Blocks.Logical.Switch switch2
      annotation (Placement(transformation(extent={{8,8},{-8,-8}},
          rotation=180,
          origin={64,-104})));
    Modelica.Blocks.Sources.ContinuousClock continuousClock1(offset=0)
      annotation (Placement(transformation(extent={{7,-7},{-7,7}},
          rotation=180,
          origin={-19,-103})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=300)
      annotation (Placement(transformation(extent={{6,-6},{-6,6}},
          rotation=180,
          origin={32,-104})));
    Modelica.Blocks.Sources.Constant FULL_PWR(k=4.147e7)
      annotation (Placement(transformation(extent={{-88,-136},{-68,-116}})));
    Modelica.Blocks.Math.Product product2
      annotation (Placement(transformation(extent={{-34,-88},{-18,-72}})));
  equation
    connect(p_Control.y, nuScaleModule_v5_1.CR_reactivity) annotation (Line(
          points={{-123,18},{-70,18},{-70,-8},{-71.15,-8},{-71.15,-12}},
                                                                color={0,0,127}));
    connect(nuScaleModule_v5_1.Core_Tavg, p_Control.u_m) annotation (Line(
          points={{-70.7375,-16.4231},{-134,-16.4231},{-134,6}},         color=
            {0,0,127}));
    connect(const.y, p_Control.u_s) annotation (Line(points={{-159,18},{-146,18}},
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
            -51.4875,-19.1154},{-51.4875,-20},{2,-20},{2,-20.4},{59.3286,-20.4}},
          color={0,127,255}));
    connect(nuScaleModule_v5_1.port_b, BOP_mdot.port_b) annotation (Line(points={{
            -51.2125,-38.7308},{-51.2125,-38},{59.1071,-38},{59.1071,-37.6}},
          color={0,127,255}));
    connect(PID.y, BOP_mdot.T_valve1) annotation (Line(points={{64,3.2},{64,-8},
            {63.5357,-8},{63.5357,-12}}, color={0,0,127}));
    connect(continuousClock1.y, lessThreshold1.u)
      annotation (Line(points={{-11.3,-103},{24.8,-104}}, color={0,0,127}));
    connect(switch2.u2, lessThreshold1.y)
      annotation (Line(points={{54.4,-104},{38.6,-104}}, color={255,0,255}));
    connect(switch2.y, PID1.u_m) annotation (Line(points={{72.8,-104},{92,-104},
            {92,-89.6}}, color={0,0,127}));
    connect(PID1.y, BOP_mdot.FW_Pump) annotation (Line(points={{100.8,-80},{108,
            -80},{108,-68},{108.375,-68},{108.375,-59}}, color={0,0,127}));
    connect(product2.y, PID1.u_s)
      annotation (Line(points={{-17.2,-80},{82.4,-80}}, color={0,0,127}));
    connect(product2.u2, FULL_PWR.y) annotation (Line(points={{-35.6,-84.8},{
            -50,-84.8},{-50,-126},{-67,-126}}, color={0,0,127}));
    connect(switch1.u1, const1.y) annotation (Line(points={{8.4,47.6},{66,47.6},
            {66,49},{83.3,49}}, color={0,0,127}));
    connect(switch1.u3, nuScaleModule_v5_1.SG_press) annotation (Line(points={{
            -4.4,47.6},{-54.5125,47.6},{-54.5125,-8.73077}}, color={0,0,127}));
    connect(product2.u1, const3.y) annotation (Line(points={{-35.6,-75.2},{-74,
            -75.2},{-74,-66},{-95.4,-66}}, color={0,0,127}));
    connect(switch2.u1, BOP_mdot.W_Sensor) annotation (Line(points={{54.4,-97.6},
            {54.4,-68},{76,-68},{76,-64},{77.2643,-64},{77.2643,-60}}, color={0,
            0,127}));
    connect(switch2.u3, FULL_PWR.y) annotation (Line(points={{54.4,-110.4},{
            54.4,-126},{-67,-126}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
              -160},{220,120}})),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,
              120}})),
      experiment(
        StopTime=1210000,
        Interval=100,
        Tolerance=1e-05,
        __Dymola_Algorithm="Esdirk45a"));
  end PowerPlant_actuator;

  model PowerPlant_fwp
    Reactor.NuScaleModule_v5 nuScaleModule_v5_1
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
      annotation (Placement(transformation(extent={{-180,8},{-160,28}})));
    Modelica.Blocks.Sources.Constant const1(k=3.39e+06)
      annotation (Placement(transformation(extent={{98,42},{84,56}})));
    TRANSFORM.Controls.P_Control p_Control(k=0.005)
      annotation (Placement(transformation(extent={{-144,8},{-124,28}})));
    Modelica.Blocks.Sources.TimeTable LF_sample(table=[0,1; 86400,1; 108000,1;
          108900,0.8; 130500,0.8; 131400,1; 194400,1; 195300,0.8; 216900,0.8;
          217800,1; 280800,1; 281700,0.8; 303300,0.8; 304200,1; 367200,1;
          368100,0.8; 389700,0.8; 390600,1; 518400,1])
      annotation (Placement(transformation(extent={{-154,-108},{-142,-96}})));
    Modelica.Blocks.Sources.TimeTable LF_profilev1(table=[0,1; 86400,1; 108000,
          1; 109200,0.8; 130800,0.8; 132000,1; 150000,1; 150600,0.9; 175800,0.9;
          176400,1; 280800,1; 282000,0.8; 303600,0.8; 304800,1; 363600,1;
          364200,0.9; 375000,0.9; 375600,1; 453600,1; 454800,0.8; 476400,0.8;
          477600,1; 640800,1; 641400,90; 655800,90; 656400,1; 712800,1; 714000,
          80; 735600,80; 736800,1; 885600,1; 886800,80; 908400,80; 909600,1;
          975600,1; 976200,0.9; 994200,0.90; 994800,1; 1058400,1; 1059600,0.80;
          1081200,0.80; 1082400,1; 1123200,1; 1209600,1])
      annotation (Placement(transformation(extent={{-138,-122},{-126,-110}})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{8,-8},{-8,8}},
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
      yMin=0) annotation (Placement(transformation(extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={64,12})));
    Modelica.Blocks.Sources.Constant const3(k=1)
      annotation (Placement(transformation(extent={{-170,-90},{-158,-78}})));
    BOP.NuScaleBOP_fwp     BOP_mdot
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
          origin={32,-98})));
    Modelica.Blocks.Logical.Switch switch2
      annotation (Placement(transformation(extent={{8,-8},{-8,8}},
          rotation=180,
          origin={2,-122})));
    Modelica.Blocks.Sources.ContinuousClock continuousClock1(offset=0)
      annotation (Placement(transformation(extent={{7,-7},{-7,7}},
          rotation=180,
          origin={-81,-121})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=300)
      annotation (Placement(transformation(extent={{6,-6},{-6,6}},
          rotation=180,
          origin={-30,-122})));
    Modelica.Blocks.Sources.Constant FULL_PWR(k=4.147e7)
      annotation (Placement(transformation(extent={{-150,-154},{-130,-134}})));
    Modelica.Blocks.Math.Product product2
      annotation (Placement(transformation(extent={{-96,-106},{-80,-90}})));
    Extra_Equipment.decr_func decr_func annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={110,-118})));
    Modelica.Blocks.Sources.Constant t_step(k=0.6e6)
      annotation (Placement(transformation(extent={{8,-8},{-8,8}},
          rotation=-90,
          origin={110,-148})));
    Modelica.Blocks.Sources.ContinuousClock t(offset=0) annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=90,
          origin={137,-149})));
    Modelica.Blocks.Sources.Constant min_Tvalve(k=0.9)
      annotation (Placement(transformation(extent={{8,-8},{-8,8}},
          rotation=-90,
          origin={74,-148})));
    Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=90,
          origin={86,-88})));
  equation
    connect(p_Control.y, nuScaleModule_v5_1.CR_reactivity) annotation (Line(
          points={{-123,18},{-70,18},{-70,-8},{-71.15,-8},{-71.15,-12}},
                                                                color={0,0,127}));
    connect(nuScaleModule_v5_1.Core_Tavg, p_Control.u_m) annotation (Line(
          points={{-70.7375,-16.4231},{-134,-16.4231},{-134,6}},         color=
            {0,0,127}));
    connect(const.y, p_Control.u_s) annotation (Line(points={{-159,18},{-146,18}},
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
            -51.4875,-20.2692},{-51.4875,-20},{2,-20},{2,-20.4},{59.3286,-20.4}},
          color={0,127,255}));
    connect(nuScaleModule_v5_1.port_b, BOP_mdot.port_b) annotation (Line(points={{
            -51.4875,-50.2692},{-51.4875,-38},{59.1071,-38},{59.1071,-37.6}},
          color={0,127,255}));
    connect(PID.y, BOP_mdot.T_valve1) annotation (Line(points={{64,3.2},{64,-8},
            {63.5357,-8},{63.5357,-12}}, color={0,0,127}));
    connect(continuousClock1.y, lessThreshold1.u)
      annotation (Line(points={{-73.3,-121},{-37.2,-122}}, color={0,0,127}));
    connect(switch2.u2, lessThreshold1.y)
      annotation (Line(points={{-7.6,-122},{-23.4,-122}}, color={255,0,255}));
    connect(switch2.y, PID1.u_m) annotation (Line(points={{10.8,-122},{32,-122},
            {32,-107.6}}, color={0,0,127}));
    connect(const3.y, product2.u1) annotation (Line(points={{-157.4,-84},{-134,
            -84},{-134,-92},{-97.6,-92},{-97.6,-93.2}}, color={0,0,127}));
    connect(product2.y, PID1.u_s)
      annotation (Line(points={{-79.2,-98},{22.4,-98}}, color={0,0,127}));
    connect(product2.u2, FULL_PWR.y) annotation (Line(points={{-97.6,-102.8},{
            -112,-102.8},{-112,-144},{-129,-144}}, color={0,0,127}));
    connect(t_step.y,decr_func. time_step)
      annotation (Line(points={{110,-139.2},{110,-126.2}},
                                                       color={0,0,127}));
    connect(product1.y, BOP_mdot.FW_Pump) annotation (Line(points={{86,-79.2},{
            86,-68},{108.375,-68},{108.375,-59}}, color={0,0,127}));
    connect(PID1.y, product1.u1)
      annotation (Line(points={{40.8,-98},{81.2,-97.6}}, color={0,0,127}));
    connect(product1.u2, decr_func.mult_factor) annotation (Line(points={{90.8,
            -97.6},{110,-97.6},{110,-109.8}}, color={0,0,127}));
    connect(decr_func.min_val, min_Tvalve.y) annotation (Line(points={{105.2,
            -124},{74,-124},{74,-139.2}}, color={0,0,127}));
    connect(decr_func.clock, t.y) annotation (Line(points={{114.8,-124},{136,
            -124},{136,-138},{137,-138},{137,-141.3}}, color={0,0,127}));
    connect(const1.y, switch1.u3) annotation (Line(points={{83.3,49},{16,49},{
            16,47.6},{8.4,47.6}}, color={0,0,127}));
    connect(switch1.u1, nuScaleModule_v5_1.SG_press) annotation (Line(points={{
            -4.4,47.6},{-54.5125,47.6},{-54.5125,-8.73077}}, color={0,0,127}));
    connect(switch2.u1, FULL_PWR.y) annotation (Line(points={{-7.6,-128.4},{-6,
            -128.4},{-6,-144},{-129,-144}}, color={0,0,127}));
    connect(switch2.u3, BOP_mdot.W_Sensor) annotation (Line(points={{-7.6,
            -115.6},{-14,-115.6},{-14,-68},{76,-68},{76,-64},{77.2643,-64},{
            77.2643,-60}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
              -160},{220,120}})),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,
              120}})),
      experiment(
        StopTime=1210000,
        Interval=100,
        Tolerance=1e-05,
        __Dymola_Algorithm="Esdirk45a"));
  end PowerPlant_fwp;

  model PowerPlant_fwp_and_leak
    Reactor.NuScaleModule_v5 nuScaleModule_v5_1
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
      annotation (Placement(transformation(extent={{-180,8},{-160,28}})));
    Modelica.Blocks.Sources.Constant const1(k=3.39e+06)
      annotation (Placement(transformation(extent={{98,42},{84,56}})));
    TRANSFORM.Controls.P_Control p_Control(k=0.005)
      annotation (Placement(transformation(extent={{-144,8},{-124,28}})));
    Modelica.Blocks.Sources.TimeTable LF_sample(table=[0,1; 86400,1; 108000,1;
          108900,0.8; 130500,0.8; 131400,1; 194400,1; 195300,0.8; 216900,0.8;
          217800,1; 280800,1; 281700,0.8; 303300,0.8; 304200,1; 367200,1;
          368100,0.8; 389700,0.8; 390600,1; 518400,1])
      annotation (Placement(transformation(extent={{-154,-108},{-142,-96}})));
    Modelica.Blocks.Sources.TimeTable LF_profilev1(table=[0,1; 86400,1; 108000,
          1; 109200,0.8; 130800,0.8; 132000,1; 150000,1; 150600,0.9; 175800,0.9;
          176400,1; 280800,1; 282000,0.8; 303600,0.8; 304800,1; 363600,1;
          364200,0.9; 375000,0.9; 375600,1; 453600,1; 454800,0.8; 476400,0.8;
          477600,1; 640800,1; 641400,90; 655800,90; 656400,1; 712800,1; 714000,
          80; 735600,80; 736800,1; 885600,1; 886800,80; 908400,80; 909600,1;
          975600,1; 976200,0.9; 994200,0.90; 994800,1; 1058400,1; 1059600,0.80;
          1081200,0.80; 1082400,1; 1123200,1; 1209600,1])
      annotation (Placement(transformation(extent={{-138,-122},{-126,-110}})));
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
      yMin=0) annotation (Placement(transformation(extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={64,12})));
    Modelica.Blocks.Sources.Constant const3(k=1)
      annotation (Placement(transformation(extent={{-170,-90},{-158,-78}})));
    BOP.NuScaleBOP_fwp_and_leak
                           BOP_mdot
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
          origin={32,-98})));
    Modelica.Blocks.Logical.Switch switch2
      annotation (Placement(transformation(extent={{8,-8},{-8,8}},
          rotation=180,
          origin={2,-122})));
    Modelica.Blocks.Sources.ContinuousClock continuousClock1(offset=0)
      annotation (Placement(transformation(extent={{7,-7},{-7,7}},
          rotation=180,
          origin={-81,-121})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=300)
      annotation (Placement(transformation(extent={{6,-6},{-6,6}},
          rotation=180,
          origin={-30,-122})));
    Modelica.Blocks.Sources.Constant FULL_PWR(k=4.147e7)
      annotation (Placement(transformation(extent={{-150,-154},{-130,-134}})));
    Modelica.Blocks.Math.Product product2
      annotation (Placement(transformation(extent={{-96,-106},{-80,-90}})));
    Extra_Equipment.decr_func decr_func annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={108,-108})));
    Modelica.Blocks.Sources.Constant t_step(k=1.2e6)
      annotation (Placement(transformation(extent={{8,-8},{-8,8}},
          rotation=-90,
          origin={106,-148})));
    Modelica.Blocks.Sources.ContinuousClock t(offset=0) annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=90,
          origin={137,-149})));
    Modelica.Blocks.Sources.Constant min_Tvalve(k=0.9)
      annotation (Placement(transformation(extent={{8,-8},{-8,8}},
          rotation=-90,
          origin={74,-148})));
    Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=90,
          origin={86,-88})));
  equation
    connect(p_Control.y, nuScaleModule_v5_1.CR_reactivity) annotation (Line(
          points={{-123,18},{-70,18},{-70,-8},{-71.15,-8},{-71.15,-12}},
                                                                color={0,0,127}));
    connect(nuScaleModule_v5_1.Core_Tavg, p_Control.u_m) annotation (Line(
          points={{-70.7375,-16.4231},{-134,-16.4231},{-134,6}},         color=
            {0,0,127}));
    connect(const.y, p_Control.u_s) annotation (Line(points={{-159,18},{-146,18}},
                                  color={0,0,127}));
    connect(continuousClock.y, lessThreshold.u) annotation (Line(points={{3,93.3},
            {2,93.3},{2,83.2}},                      color={0,0,127}));
    connect(lessThreshold.y, switch1.u2)
      annotation (Line(points={{2,69.4},{0,69.4},{0,70},{2,70},{2,47.6}},
                                                       color={255,0,255}));
    connect(switch1.y, PID.u_m) annotation (Line(points={{2,29.2},{2,12},{54.4,
            12}},                 color={0,0,127}));
    connect(const1.y, switch1.u1) annotation (Line(points={{83.3,49},{16,49},{
            16,47.6},{8.4,47.6}},            color={0,0,127}));
    connect(const1.y, PID.u_s) annotation (Line(points={{83.3,49},{64,49},{64,
            21.6}},                 color={0,0,127}));
    connect(nuScaleModule_v5_1.SG_press, switch1.u3) annotation (Line(points={{
            -54.5125,-8.73077},{-54.5125,47.6},{-4.4,47.6}}, color={0,0,127}));
    connect(nuScaleModule_v5_1.port_a, BOP_mdot.port_a) annotation (Line(points={{
            -51.4875,-19.1154},{-51.4875,-20},{2,-20},{2,-20.4},{59.3286,-20.4}},
          color={0,127,255}));
    connect(nuScaleModule_v5_1.port_b, BOP_mdot.port_b) annotation (Line(points={{
            -51.2125,-38.7308},{-51.2125,-38},{59.1071,-38},{59.1071,-37.6}},
          color={0,127,255}));
    connect(PID.y, BOP_mdot.T_valve1) annotation (Line(points={{64,3.2},{64,-8},
            {63.5357,-8},{63.5357,-12}}, color={0,0,127}));
    connect(continuousClock1.y, lessThreshold1.u)
      annotation (Line(points={{-73.3,-121},{-37.2,-122}}, color={0,0,127}));
    connect(switch2.u2, lessThreshold1.y)
      annotation (Line(points={{-7.6,-122},{-23.4,-122}}, color={255,0,255}));
    connect(switch2.y, PID1.u_m) annotation (Line(points={{10.8,-122},{32,-122},
            {32,-107.6}}, color={0,0,127}));
    connect(const3.y, product2.u1) annotation (Line(points={{-157.4,-84},{-134,
            -84},{-134,-92},{-97.6,-92},{-97.6,-93.2}}, color={0,0,127}));
    connect(product2.y, PID1.u_s)
      annotation (Line(points={{-79.2,-98},{22.4,-98}}, color={0,0,127}));
    connect(product2.u2, FULL_PWR.y) annotation (Line(points={{-97.6,-102.8},{
            -112,-102.8},{-112,-144},{-129,-144}}, color={0,0,127}));
    connect(t_step.y,decr_func. time_step)
      annotation (Line(points={{106,-139.2},{106,-124},{108,-124},{108,-116.2}},
                                                       color={0,0,127}));
    connect(product1.y, BOP_mdot.FW_Pump) annotation (Line(points={{86,-79.2},{
            86,-68},{108.375,-68},{108.375,-59}}, color={0,0,127}));
    connect(PID1.y, product1.u1)
      annotation (Line(points={{40.8,-98},{81.2,-97.6}}, color={0,0,127}));
    connect(product1.u2, decr_func.mult_factor) annotation (Line(points={{90.8,
            -97.6},{98,-97.6},{98,-100},{102,-100},{102,-98},{108,-98},{108,
            -99.8}}, color={0,0,127}));
    connect(decr_func.min_val, min_Tvalve.y) annotation (Line(points={{103.2,
            -114},{74,-114},{74,-139.2}}, color={0,0,127}));
    connect(decr_func.clock, t.y) annotation (Line(points={{112.8,-114},{112.8,
            -134},{136,-134},{136,-138},{137,-138},{137,-141.3}}, color={0,0,
            127}));
    connect(switch2.u1, FULL_PWR.y) annotation (Line(points={{-7.6,-128.4},{-6,
            -128.4},{-6,-144},{-129,-144}}, color={0,0,127}));
    connect(switch2.u3, BOP_mdot.W_Sensor) annotation (Line(points={{-7.6,
            -115.6},{-14,-115.6},{-14,-68},{76,-68},{76,-64},{77.2643,-64},{
            77.2643,-60}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
              -160},{220,120}})),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,
              120}})),
      experiment(
        StopTime=1210000,
        Interval=100,
        Tolerance=1e-05,
        __Dymola_Algorithm="Esdirk45a"));
  end PowerPlant_fwp_and_leak;

  model PowerPlant_fwp_2
    Reactor.NuScaleModule_v5 nuScaleModule_v5_1
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
      annotation (Placement(transformation(extent={{-180,8},{-160,28}})));
    Modelica.Blocks.Sources.Constant const1(k=3.39e+06)
      annotation (Placement(transformation(extent={{98,42},{84,56}})));
    TRANSFORM.Controls.P_Control p_Control(k=0.005)
      annotation (Placement(transformation(extent={{-144,8},{-124,28}})));
    Modelica.Blocks.Sources.TimeTable LF_sample(table=[0,1; 86400,1; 108000,1;
          108900,0.8; 130500,0.8; 131400,1; 194400,1; 195300,0.8; 216900,0.8;
          217800,1; 280800,1; 281700,0.8; 303300,0.8; 304200,1; 367200,1;
          368100,0.8; 389700,0.8; 390600,1; 518400,1])
      annotation (Placement(transformation(extent={{-154,-108},{-142,-96}})));
    Modelica.Blocks.Sources.TimeTable LF_profilev1(table=[0,1; 86400,1; 108000,
          1; 109200,0.8; 130800,0.8; 132000,1; 150000,1; 150600,0.9; 175800,0.9;
          176400,1; 280800,1; 282000,0.8; 303600,0.8; 304800,1; 363600,1;
          364200,0.9; 375000,0.9; 375600,1; 453600,1; 454800,0.8; 476400,0.8;
          477600,1; 640800,1; 641400,90; 655800,90; 656400,1; 712800,1; 714000,
          80; 735600,80; 736800,1; 885600,1; 886800,80; 908400,80; 909600,1;
          975600,1; 976200,0.9; 994200,0.90; 994800,1; 1058400,1; 1059600,0.80;
          1081200,0.80; 1082400,1; 1123200,1; 1209600,1])
      annotation (Placement(transformation(extent={{-138,-122},{-126,-110}})));
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
      yMin=0) annotation (Placement(transformation(extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={64,12})));
    Modelica.Blocks.Sources.Constant const3(k=1)
      annotation (Placement(transformation(extent={{-170,-90},{-158,-78}})));
    BOP.NuScaleBOP_fwp_2   BOP_mdot
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
          origin={32,-98})));
    Modelica.Blocks.Logical.Switch switch2
      annotation (Placement(transformation(extent={{8,-8},{-8,8}},
          rotation=180,
          origin={2,-122})));
    Modelica.Blocks.Sources.ContinuousClock continuousClock1(offset=0)
      annotation (Placement(transformation(extent={{7,-7},{-7,7}},
          rotation=180,
          origin={-81,-121})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=300)
      annotation (Placement(transformation(extent={{6,-6},{-6,6}},
          rotation=180,
          origin={-30,-122})));
    Modelica.Blocks.Sources.Constant FULL_PWR(k=4.147e7)
      annotation (Placement(transformation(extent={{-150,-154},{-130,-134}})));
    Modelica.Blocks.Math.Product product2
      annotation (Placement(transformation(extent={{-96,-106},{-80,-90}})));
    Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=90,
          origin={86,-88})));
    Modelica.Blocks.Sources.Ramp ramp(
      height=-0.05,
      duration=1.2e6,
      offset=1,
      startTime=600)
      annotation (Placement(transformation(extent={{160,-108},{140,-88}})));
  equation
    connect(p_Control.y, nuScaleModule_v5_1.CR_reactivity) annotation (Line(
          points={{-123,18},{-70,18},{-70,-8},{-71.15,-8},{-71.15,-12}},
                                                                color={0,0,127}));
    connect(nuScaleModule_v5_1.Core_Tavg, p_Control.u_m) annotation (Line(
          points={{-70.7375,-16.4231},{-134,-16.4231},{-134,6}},         color=
            {0,0,127}));
    connect(const.y, p_Control.u_s) annotation (Line(points={{-159,18},{-146,18}},
                                  color={0,0,127}));
    connect(continuousClock.y, lessThreshold.u) annotation (Line(points={{3,93.3},
            {2,93.3},{2,83.2}},                      color={0,0,127}));
    connect(lessThreshold.y, switch1.u2)
      annotation (Line(points={{2,69.4},{0,69.4},{0,70},{2,70},{2,47.6}},
                                                       color={255,0,255}));
    connect(switch1.y, PID.u_m) annotation (Line(points={{2,29.2},{2,12},{54.4,
            12}},                 color={0,0,127}));
    connect(const1.y, switch1.u1) annotation (Line(points={{83.3,49},{16,49},{
            16,47.6},{8.4,47.6}},            color={0,0,127}));
    connect(const1.y, PID.u_s) annotation (Line(points={{83.3,49},{64,49},{64,
            21.6}},                 color={0,0,127}));
    connect(nuScaleModule_v5_1.SG_press, switch1.u3) annotation (Line(points={{
            -54.5125,-8.73077},{-54.5125,47.6},{-4.4,47.6}}, color={0,0,127}));
    connect(nuScaleModule_v5_1.port_a, BOP_mdot.port_a) annotation (Line(points={{
            -51.4875,-20.2692},{-51.4875,-20},{2,-20},{2,-20.4},{59.3286,-20.4}},
          color={0,127,255}));
    connect(nuScaleModule_v5_1.port_b, BOP_mdot.port_b) annotation (Line(points={{
            -51.4875,-50.2692},{-51.4875,-38},{59.1071,-38},{59.1071,-37.6}},
          color={0,127,255}));
    connect(PID.y, BOP_mdot.T_valve1) annotation (Line(points={{64,3.2},{64,-8},
            {63.5357,-8},{63.5357,-12}}, color={0,0,127}));
    connect(continuousClock1.y, lessThreshold1.u)
      annotation (Line(points={{-73.3,-121},{-37.2,-122}}, color={0,0,127}));
    connect(switch2.u2, lessThreshold1.y)
      annotation (Line(points={{-7.6,-122},{-23.4,-122}}, color={255,0,255}));
    connect(switch2.y, PID1.u_m) annotation (Line(points={{10.8,-122},{32,-122},
            {32,-107.6}}, color={0,0,127}));
    connect(const3.y, product2.u1) annotation (Line(points={{-157.4,-84},{-134,
            -84},{-134,-92},{-97.6,-92},{-97.6,-93.2}}, color={0,0,127}));
    connect(product2.y, PID1.u_s)
      annotation (Line(points={{-79.2,-98},{22.4,-98}}, color={0,0,127}));
    connect(product2.u2, FULL_PWR.y) annotation (Line(points={{-97.6,-102.8},{
            -112,-102.8},{-112,-144},{-129,-144}}, color={0,0,127}));
    connect(product1.y, BOP_mdot.FW_Pump) annotation (Line(points={{86,-79.2},{
            86,-68},{108.375,-68},{108.375,-59}}, color={0,0,127}));
    connect(PID1.y, product1.u1)
      annotation (Line(points={{40.8,-98},{81.2,-97.6}}, color={0,0,127}));
    connect(ramp.y, product1.u2) annotation (Line(points={{139,-98},{90.8,-98},
            {90.8,-97.6}}, color={0,0,127}));
    connect(switch2.u1, FULL_PWR.y) annotation (Line(points={{-7.6,-128.4},{-6,
            -128.4},{-6,-144},{-129,-144}}, color={0,0,127}));
    connect(switch2.u3, BOP_mdot.W_Sensor) annotation (Line(points={{-7.6,
            -115.6},{-14,-115.6},{-14,-68},{76,-68},{76,-64},{77.2643,-64},{
            77.2643,-60}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
              -160},{220,120}})),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,
              120}})),
      experiment(
        StopTime=1210000,
        Interval=100,
        Tolerance=1e-05,
        __Dymola_Algorithm="Esdirk45a"));
  end PowerPlant_fwp_2;

  model PowerPlant_actuator_linear
    Reactor.NuScaleModule_v5 nuScaleModule_v5_1
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
      annotation (Placement(transformation(extent={{-180,8},{-160,28}})));
    Modelica.Blocks.Sources.Constant const1(k=3.39e+06)
      annotation (Placement(transformation(extent={{98,42},{84,56}})));
    TRANSFORM.Controls.P_Control p_Control(k=0.005)
      annotation (Placement(transformation(extent={{-144,8},{-124,28}})));
    Modelica.Blocks.Sources.TimeTable LF_sample(table=[0,1; 86400,1; 108000,1;
          108900,0.8; 130500,0.8; 131400,1; 194400,1; 195300,0.8; 216900,0.8;
          217800,1; 280800,1; 281700,0.8; 303300,0.8; 304200,1; 367200,1;
          368100,0.8; 389700,0.8; 390600,1; 518400,1])
      annotation (Placement(transformation(extent={{-92,-90},{-80,-78}})));
    Modelica.Blocks.Sources.TimeTable LF_profilev1(table=[0,1; 86400,1; 108000,
          1; 109200,0.8; 130800,0.8; 132000,1; 150000,1; 150600,0.9; 175800,0.9;
          176400,1; 280800,1; 282000,0.8; 303600,0.8; 304800,1; 363600,1;
          364200,0.9; 375000,0.9; 375600,1; 453600,1; 454800,0.8; 476400,0.8;
          477600,1; 640800,1; 641400,0.9; 655800,0.9; 656400,1; 712800,1;
          714000,0.8; 735600,0.8; 736800,1; 885600,1; 886800,0.8; 908400,0.8;
          909600,1; 975600,1; 976200,0.9; 994200,0.9; 994800,1; 1058400,1;
          1059600,0.8; 1081200,0.8; 1082400,1; 1123200,1; 1209600,1])
      annotation (Placement(transformation(extent={{-76,-104},{-64,-92}})));
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
      yMin=0) annotation (Placement(transformation(extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={64,12})));
    Modelica.Blocks.Sources.Constant const3(k=1)
      annotation (Placement(transformation(extent={{-108,-72},{-96,-60}})));
    BOP.NuScaleBOP_actuator_linear
                            BOP_mdot
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
          origin={92,-80})));
    Modelica.Blocks.Logical.Switch switch2
      annotation (Placement(transformation(extent={{8,8},{-8,-8}},
          rotation=180,
          origin={64,-104})));
    Modelica.Blocks.Sources.ContinuousClock continuousClock1(offset=0)
      annotation (Placement(transformation(extent={{7,-7},{-7,7}},
          rotation=180,
          origin={-19,-103})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=300)
      annotation (Placement(transformation(extent={{6,-6},{-6,6}},
          rotation=180,
          origin={32,-104})));
    Modelica.Blocks.Sources.Constant FULL_PWR(k=4.147e7)
      annotation (Placement(transformation(extent={{-88,-136},{-68,-116}})));
    Modelica.Blocks.Math.Product product2
      annotation (Placement(transformation(extent={{-34,-88},{-18,-72}})));
  equation
    connect(p_Control.y, nuScaleModule_v5_1.CR_reactivity) annotation (Line(
          points={{-123,18},{-70,18},{-70,-8},{-71.15,-8},{-71.15,-12}},
                                                                color={0,0,127}));
    connect(nuScaleModule_v5_1.Core_Tavg, p_Control.u_m) annotation (Line(
          points={{-70.7375,-16.4231},{-134,-16.4231},{-134,6}},         color=
            {0,0,127}));
    connect(const.y, p_Control.u_s) annotation (Line(points={{-159,18},{-146,18}},
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
            -51.4875,-19.1154},{-51.4875,-20},{2,-20},{2,-20.4},{59.3286,-20.4}},
          color={0,127,255}));
    connect(nuScaleModule_v5_1.port_b, BOP_mdot.port_b) annotation (Line(points={{
            -51.2125,-38.7308},{-51.2125,-38},{59.1071,-38},{59.1071,-37.6}},
          color={0,127,255}));
    connect(PID.y, BOP_mdot.T_valve1) annotation (Line(points={{64,3.2},{64,-8},
            {63.5357,-8},{63.5357,-12}}, color={0,0,127}));
    connect(continuousClock1.y, lessThreshold1.u)
      annotation (Line(points={{-11.3,-103},{24.8,-104}}, color={0,0,127}));
    connect(switch2.u2, lessThreshold1.y)
      annotation (Line(points={{54.4,-104},{38.6,-104}}, color={255,0,255}));
    connect(switch2.y, PID1.u_m) annotation (Line(points={{72.8,-104},{92,-104},
            {92,-89.6}}, color={0,0,127}));
    connect(PID1.y, BOP_mdot.FW_Pump) annotation (Line(points={{100.8,-80},{108,
            -80},{108,-68},{108.375,-68},{108.375,-59}}, color={0,0,127}));
    connect(product2.y, PID1.u_s)
      annotation (Line(points={{-17.2,-80},{82.4,-80}}, color={0,0,127}));
    connect(product2.u2, FULL_PWR.y) annotation (Line(points={{-35.6,-84.8},{
            -50,-84.8},{-50,-126},{-67,-126}}, color={0,0,127}));
    connect(switch1.u1, const1.y) annotation (Line(points={{8.4,47.6},{66,47.6},
            {66,49},{83.3,49}}, color={0,0,127}));
    connect(switch1.u3, nuScaleModule_v5_1.SG_press) annotation (Line(points={{
            -4.4,47.6},{-54.5125,47.6},{-54.5125,-8.73077}}, color={0,0,127}));
    connect(product2.u1, const3.y) annotation (Line(points={{-35.6,-75.2},{-74,
            -75.2},{-74,-66},{-95.4,-66}}, color={0,0,127}));
    connect(switch2.u1, BOP_mdot.W_Sensor) annotation (Line(points={{54.4,-97.6},
            {54.4,-68},{76,-68},{76,-64},{77.2643,-64},{77.2643,-60}}, color={0,
            0,127}));
    connect(switch2.u3, FULL_PWR.y) annotation (Line(points={{54.4,-110.4},{
            54.4,-126},{-67,-126}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
              -160},{220,120}})),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,
              120}})),
      experiment(
        StopTime=1210000,
        Interval=100,
        Tolerance=1e-05,
        __Dymola_Algorithm="Esdirk45a"));
  end PowerPlant_actuator_linear;

  model PowerPlant_NPIC
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
    Modelica.Blocks.Sources.TimeTable LF(table=[0,1; 86400,1; 108000,1; 109200,
          0.8; 130800,0.8; 132000,1; 150000,1; 150600,0.9; 175800,0.9; 176400,1;
          280800,1; 282000,0.8; 303600,0.8; 304800,1; 363600,1; 364200,0.9;
          375000,0.9; 375600,1; 453600,1; 454800,0.8; 476400,0.8; 477600,1;
          640800,1; 641400,0.9; 655800,0.9; 656400,1; 712800,1; 714000,0.8;
          735600,0.8; 736800,1; 885600,1; 886800,0.8; 908400,0.8; 909600,1;
          975600,1; 976200,0.9; 994200,0.90; 994800,1; 1058400,1; 1059600,0.80;
          1081200,0.80; 1082400,1; 1123200,1; 1209600,1], nextEvent(start=
            86400.0))
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
    Modelica.Blocks.Sources.Constant SS(k=1)
      annotation (Placement(transformation(extent={{-152,-82},{-140,-70}})));
    BOP.NuScaleBOP_NPIC    BOP_mdot(
      LF_profilev1(nextEvent(start=86400.0)),
      TCV1(port_b(h_outflow(start=2978967.5000000536))),
      TCV2(port_b(h_outflow(start=2978967.5000000536))),
      leak_resistor1(port_a(p(start=101325.0))))
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
          origin={108,-80})));
    Modelica.Blocks.Sources.Ramp FWP_ramp(
      height=-0.02,
      duration=1.2e6,
      offset=1,
      startTime=1000)
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
    Modelica.Blocks.Sources.TimeTable validation(table=[0,1; 86400,1; 108000,
          0.95; 109200,0.75; 130800,0.75; 132000,0.95; 150000,0.95; 150600,0.85;
          175800,0.85; 176400,0.95; 280800,0.95; 282000,0.75; 303600,0.75;
          304800,0.95; 363600,0.95; 364200,0.85; 375000,0.85; 375600,0.95;
          453600,0.95; 454800,0.75; 476400,0.75; 477600,0.95; 640800,0.95;
          641400,0.85; 655800,0.85; 656400,0.95; 712800,0.95; 714000,0.75;
          735600,0.75; 736800,0.95; 885600,0.95; 886800,0.75; 908400,0.75;
          909600,0.95; 975600,0.95; 976200,0.85; 994200,0.85; 994800,0.95;
          1058400,0.95; 1059600,0.75; 1081200,0.75; 1082400,0.95; 1123200,0.95;
          1209600,0.95; 1209600,0.9; 1296000,0.9; 1317600,0.9; 1318800,0.7;
          1340400,0.7; 1341600,0.9; 1359600,0.9; 1360200,0.8; 1385400,0.8;
          1386000,0.9; 1490400,0.9; 1491600,0.7; 1513200,0.7; 1514400,0.9;
          1573200,0.9; 1573800,0.8; 1584600,0.8; 1585200,0.9; 1663200,0.9;
          1664400,0.7; 1686000,0.7; 1687200,0.9; 1850400,0.9; 1851000,0.8;
          1865400,0.8; 1866000,0.9; 1922400,0.9; 1923600,0.7; 1945200,0.7;
          1946400,0.9; 2095200,0.9; 2096400,0.7; 2118000,0.7; 2119200,0.9;
          2185200,0.9; 2185800,0.8; 2203800,0.8; 2204400,0.9; 2268000,0.9;
          2269200,0.7; 2290800,0.7; 2292000,0.9; 2332800,0.9; 2419200,0.9])
      annotation (Placement(transformation(extent={{-186,-66},{-166,-46}})));
    Modelica.Blocks.Sources.TimeTable training1(table=[0,1; 86400,1; 108000,1;
          109200,0.8; 130800,0.8; 132000,1; 150000,1; 150600,0.9; 175800,0.9;
          176400,1; 280800,1; 282000,0.8; 303600,0.8; 304800,1; 363600,1;
          364200,0.9; 375000,0.9; 375600,1; 453600,1; 454800,0.8; 476400,0.8;
          477600,1; 640800,1; 641400,0.9; 655800,0.9; 656400,1; 712800,1;
          714000,0.8; 735600,0.8; 736800,1; 885600,1; 886800,0.8; 908400,0.8;
          909600,1; 975600,1; 976200,0.9; 994200,0.9; 994800,1; 1058400,1;
          1059600,0.8; 1081200,0.8; 1082400,1; 1123200,1; 1209600,1; 1209600,1;
          1296000,1; 1317600,1; 1318800,0.8; 1340400,0.8; 1341600,1; 1359600,1;
          1360200,0.9; 1385400,0.9; 1386000,1; 1490400,1; 1491600,0.8; 1513200,
          0.8; 1514400,1; 1573200,1; 1573800,0.9; 1584600,0.9; 1585200,1;
          1663200,1; 1664400,0.8; 1686000,0.8; 1687200,1; 1850400,1; 1851000,
          0.9; 1865400,0.9; 1866000,1; 1922400,1; 1923600,0.8; 1945200,0.8;
          1946400,1; 2095200,1; 2096400,0.8; 2118000,0.8; 2119200,1; 2185200,1;
          2185800,0.9; 2203800,0.9; 2204400,1; 2268000,1; 2269200,0.8; 2290800,
          0.8; 2292000,1; 2332800,1; 2419200,1; 2419200,1; 2505600,1; 2527200,1;
          2528400,0.8; 2550000,0.8; 2551200,1; 2569200,1; 2569800,0.9; 2595000,
          0.9; 2595600,1; 2700000,1; 2701200,0.8; 2722800,0.8; 2724000,1;
          2782800,1; 2783400,0.9; 2794200,0.9; 2794800,1; 2872800,1; 2874000,
          0.8; 2895600,0.8; 2896800,1; 3060000,1; 3060600,0.9; 3075000,0.9;
          3075600,1; 3132000,1; 3133200,0.8; 3154800,0.8; 3156000,1; 3304800,1;
          3306000,0.8; 3327600,0.8; 3328800,1; 3394800,1; 3395400,0.9; 3413400,
          0.9; 3414000,1; 3477600,1; 3478800,0.8; 3500400,0.8; 3501600,1;
          3542400,1; 3628800,1; 4838400,1; 4839600,0.8; 5300000,0.8; 5500000,1;
          5700000,1; 5800000,0.9; 6650000,0.9; 6670000,1; 7880000,1; 7890000,
          0.9; 9090000,0.9; 9100000,0.8; 10300000,0.8])
      annotation (Placement(transformation(extent={{-186,-108},{-166,-88}})));
    Modelica.Blocks.Sources.TimeTable residuals(table=[0,1; 86400,1; 108000,1;
          109200,0.8; 130800,0.8; 132000,1; 150000,1; 150600,0.9; 175800,0.9;
          176400,1; 280800,1; 282000,0.8; 303600,0.8; 304800,1; 363600,1;
          364200,0.9; 375000,0.9; 375600,1; 453600,1; 454800,0.8; 476400,0.8;
          477600,1; 640800,1; 641400,0.9; 655800,0.9; 656400,1; 712800,1;
          714000,0.8; 735600,0.8; 736800,1; 885600,1; 886800,0.8; 908400,0.8;
          909600,1; 975600,1; 976200,0.9; 994200,0.9; 994800,1; 1058400,1;
          1059600,0.8; 1081200,0.8; 1082400,1; 1123200,1; 1209600,1; 2419200,1])
      annotation (Placement(transformation(extent={{-134,-56},{-114,-36}})));
    Modelica.Blocks.Sources.TimeTable training2(table=[0,1; 1210000,1; 1220000,
          0.9; 2420000,0.9; 2430000,0.8; 3630000,0.8])
      annotation (Placement(transformation(extent={{-184,-144},{-164,-124}})));
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
            -51.4875,-20.2692},{-51.4875,-20},{2,-20},{2,-20.4},{59.55,-20.4}},
          color={0,127,255}));
    connect(nuScaleModule_v5_1.port_b, BOP_mdot.port_b) annotation (Line(points={{
            -51.4875,-50.2692},{-51.4875,-50},{58.8857,-50},{58.8857,-49.6}},
          color={0,127,255}));
    connect(PID.y, BOP_mdot.T_valve1) annotation (Line(points={{64,3.2},{64,-8},
            {64.8643,-8},{64.8643,-14}}, color={0,0,127}));
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
    connect(switch2.u3, BOP_mdot.W_Sensor) annotation (Line(points={{10.4,
            -107.6},{10.4,-108},{6,-108},{6,-60},{77.2643,-60}},
                                                         color={0,0,127}));
    connect(switch2.u1, FULL_PWR.y) annotation (Line(points={{10.4,-120.4},{
            10.4,-136},{-111,-136}},color={0,0,127}));
    connect(switch1.u1, const1.y) annotation (Line(points={{8.4,47.6},{64,47.6},
            {64,49},{83.3,49}}, color={0,0,127}));
    connect(switch1.u3, nuScaleModule_v5_1.SG_press) annotation (Line(points={{
            -4.4,47.6},{-54.5125,47.6},{-54.5125,-8.73077}}, color={0,0,127}));
    connect(BOP_mdot.FW_Pump, FWD_multipier.y)
      annotation (Line(points={{108.375,-59},{108,-71.2}}, color={0,0,127}));
    connect(PID1.y, FWD_multipier.u1) annotation (Line(points={{54.8,-90},{94,
            -90},{94,-89.6},{103.2,-89.6}}, color={0,0,127}));
    connect(realExpression2.y, SG_P)
      annotation (Line(points={{171,-30},{202,-30}}, color={0,0,127}));
    connect(training1.y, product2.u1) annotation (Line(points={{-165,-98},{-146,
            -98},{-146,-110},{-94,-110},{-94,-85.2},{-79.6,-85.2}}, color={0,0,
            127}));
    connect(no_FWP.y, FWD_multipier.u2) annotation (Line(points={{127.3,-133},{
            112.8,-133},{112.8,-89.6}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
              -160},{220,120}})),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,
              120}})),
      experiment(
        StopTime=10300000,
        Interval=5,
        Tolerance=1e-05,
        __Dymola_Algorithm="Esdirk45a"));
  end PowerPlant_NPIC;

  model PowerPlant_NPIC_TBP
    Reactor.NuScaleModule_v5_TBP
                             nuScaleModule_v5_TBP
      annotation (Placement(transformation(extent={{-82,-50},{-38,0}})));
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
    TRANSFORM.Controls.P_Control p_Control(k=0.005)
      annotation (Placement(transformation(extent={{-144,-6},{-124,14}})));
    Modelica.Blocks.Sources.TimeTable LF_profilev1(table=[0,1; 86400,1; 108000,
          1; 109200,0.8; 130800,0.8; 132000,1; 150000,1; 150600,0.9; 175800,0.9;
          176400,1; 280800,1; 282000,0.8; 303600,0.8; 304800,1; 363600,1;
          364200,0.9; 375000,0.9; 375600,1; 453600,1; 454800,0.8; 476400,0.8;
          477600,1; 640800,1; 641400,0.9; 655800,0.9; 656400,1; 712800,1;
          714000,0.8; 735600,0.8; 736800,1; 885600,1; 886800,0.8; 908400,0.8;
          909600,1; 975600,1; 976200,0.9; 994200,0.90; 994800,1; 1058400,1;
          1059600,0.80; 1081200,0.80; 1082400,1; 1123200,1; 1209600,1])
      annotation (Placement(transformation(extent={{142,40},{130,52}})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{8,8},{-8,-8}},
          rotation=90,
          origin={54,46})));
    Modelica.Blocks.Sources.ContinuousClock continuousClock(offset=0)
      annotation (Placement(transformation(extent={{7,-7},{-7,7}},
          rotation=90,
          origin={3,101})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=300)
      annotation (Placement(transformation(extent={{6,-6},{-6,6}},
          rotation=90,
          origin={2,80})));
    TRANSFORM.Controls.LimPID PID_TCV(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      with_FF=false,
      k=1,
      yb=1,
      k_s=1/FULL_PWR.k,
      k_m=1/FULL_PWR.k,
      yMax=1,
      yMin=0) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={86,24})));
    Modelica.Blocks.Sources.Constant const3(k=1)
      annotation (Placement(transformation(extent={{130,62},{118,74}})));
    BOP.NuScaleBOP_NPIC_TBP BOP_mdot
      annotation (Placement(transformation(extent={{26,-62},{106,14}})));
    Modelica.Blocks.Sources.Constant FULL_PWR(k=4.147e7)
      annotation (Placement(transformation(extent={{124,94},{104,114}})));
    Modelica.Blocks.Math.Product product1
      annotation (Placement(transformation(extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={86,52})));
    Modelica.Blocks.Sources.Constant nom_sg_enth(k=2.99236e6) annotation (
        Placement(transformation(
          extent={{7,-7},{-7,7}},
          rotation=180,
          origin={47,-101})));
    Modelica.Blocks.Logical.Switch switch2
      annotation (Placement(transformation(extent={{8,8},{-8,-8}},
          rotation=180,
          origin={70,-144})));
    Modelica.Blocks.Sources.ContinuousClock continuousClock1(offset=0)
      annotation (Placement(transformation(extent={{7,-7},{-7,7}},
          rotation=180,
          origin={13,-143})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=300)
      annotation (Placement(transformation(extent={{6,-6},{-6,6}},
          rotation=180,
          origin={42,-144})));
    TRANSFORM.Controls.LimPID PID_FWP(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      with_FF=false,
      k=-1,
      yb=1,
      k_s=1/nom_sg_enth.k,
      k_m=1/nom_sg_enth.k,
      yMax=56,
      yMin=53) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=0,
          origin={100,-120})));
    TRANSFORM.Controls.LimPID PID_BV(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      with_FF=false,
      k=-1,
      yb=1,
      k_s=1/pwr_nom.k,
      k_m=1/pwr_nom.k,
      yMax=1,
      yMin=0,
      initType=Modelica.Blocks.Types.Init.NoInit,
      y_start=0) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=0,
          origin={-78,-108})));
    Modelica.Blocks.Logical.Switch switch3
      annotation (Placement(transformation(extent={{8,8},{-8,-8}},
          rotation=90,
          origin={-114,-140})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold2(threshold=300)
      annotation (Placement(transformation(extent={{6,-6},{-6,6}},
          rotation=180,
          origin={-178,-104})));
    Modelica.Blocks.Sources.ContinuousClock continuousClock2(offset=0)
      annotation (Placement(transformation(extent={{7,-7},{-7,7}},
          rotation=180,
          origin={-197,-103})));
    Modelica.Blocks.Sources.Constant pwr_nom(k=1.48429e8) annotation (Placement(
          transformation(
          extent={{7,-7},{-7,7}},
          rotation=180,
          origin={-119,-77})));
  equation
    connect(p_Control.y, nuScaleModule_v5_TBP.CR_reactivity) annotation (Line(
          points={{-123,4},{-100,4},{-100,-10},{-66.6,-10}}, color={0,0,127}));
    connect(nuScaleModule_v5_TBP.Core_Tavg, p_Control.u_m) annotation (Line(
          points={{-66.6,-15},{-66.6,-18},{-134,-18},{-134,-8}}, color={0,0,127}));
    connect(const.y, p_Control.u_s) annotation (Line(points={{-159,4},{-146,4}},
                                  color={0,0,127}));
    connect(continuousClock.y, lessThreshold.u) annotation (Line(points={{3,93.3},
            {2,93.3},{2,87.2}},                      color={0,0,127}));
    connect(lessThreshold.y, switch1.u2)
      annotation (Line(points={{2,73.4},{2,70},{54,70},{54,55.6}},
                                                       color={255,0,255}));
    connect(switch1.y, PID_TCV.u_m)
      annotation (Line(points={{54,37.2},{54,24},{76.4,24}}, color={0,0,127}));
    connect(nuScaleModule_v5_TBP.port_a, BOP_mdot.port_a) annotation (Line(
          points={{-47.4875,-18.2692},{28.9714,-17.6}}, color={0,127,255}));
    connect(nuScaleModule_v5_TBP.port_b, BOP_mdot.port_b) annotation (Line(
          points={{-47.4875,-48.2692},{20,-48.2692},{20,-46.8},{29.4286,-46.8}},
          color={0,127,255}));
    connect(BOP_mdot.W_Sensor, switch1.u3) annotation (Line(points={{18,30.8},{
            18,55.6},{47.6,55.6}}, color={0,0,127}));
    connect(FULL_PWR.y, switch1.u1) annotation (Line(points={{103,104},{62,104},
            {62,55.6},{60.4,55.6}}, color={0,0,127}));
    connect(PID_TCV.u_s, product1.y)
      annotation (Line(points={{86,33.6},{86,43.2}}, color={0,0,127}));
    connect(const3.y, product1.u1) annotation (Line(points={{117.4,68},{90.8,68},
            {90.8,61.6}}, color={0,0,127}));
    connect(FULL_PWR.y, product1.u2) annotation (Line(points={{103,104},{80,104},
            {80,66},{81.2,66},{81.2,61.6}}, color={0,0,127}));
    connect(continuousClock1.y, lessThreshold1.u) annotation (Line(points={{
            20.7,-143},{26,-143},{26,-144},{34.8,-144}}, color={0,0,127}));
    connect(lessThreshold1.y, switch2.u2)
      annotation (Line(points={{48.6,-144},{60.4,-144}}, color={255,0,255}));
    connect(switch2.y, PID_FWP.u_m) annotation (Line(points={{78.8,-144},{100,
            -144},{100,-129.6}}, color={0,0,127}));
    connect(PID_FWP.y, BOP_mdot.FW_Pump) annotation (Line(points={{108.8,-120},
            {112,-120},{112,-76},{84,-76},{84,-72},{85.5429,-72},{85.5429,-67.8}},
          color={0,0,127}));
    connect(nom_sg_enth.y, PID_FWP.u_s) annotation (Line(points={{54.7,-101},{
            78,-101},{78,-120},{90.4,-120}}, color={0,0,127}));
    connect(switch2.u1, PID_FWP.u_s) annotation (Line(points={{60.4,-137.6},{
            60.4,-120},{90.4,-120}}, color={0,0,127}));
    connect(switch2.u3, nuScaleModule_v5_TBP.SG_enth) annotation (Line(points={{60.4,
            -150.4},{60.4,-156},{-50,-156},{-50,-68},{-51.6125,-68},{-51.6125,
            -59.4231}},          color={0,0,127}));
    connect(PID_TCV.y, BOP_mdot.TCV_inp) annotation (Line(points={{86,15.2},{86,
            -6},{28,-6},{28,-5.2},{28.1714,-5.2}}, color={0,0,127}));
    connect(switch3.u2, lessThreshold2.y) annotation (Line(points={{-114,-130.4},
            {-114,-104},{-171.4,-104}}, color={255,0,255}));
    connect(lessThreshold2.u, continuousClock2.y) annotation (Line(points={{
            -185.2,-104},{-185.2,-103},{-189.3,-103}}, color={0,0,127}));
    connect(PID_BV.u_m, switch3.y) annotation (Line(points={{-78,-117.6},{-78,
            -152},{-114,-152},{-114,-148.8}}, color={0,0,127}));
    connect(PID_BV.u_s, pwr_nom.y) annotation (Line(points={{-87.6,-108},{-100,
            -108},{-100,-77},{-111.3,-77}}, color={0,0,127}));
    connect(switch3.u1, pwr_nom.y) annotation (Line(points={{-107.6,-130.4},{
            -100,-130.4},{-100,-77},{-111.3,-77}}, color={0,0,127}));
    connect(PID_BV.y, BOP_mdot.BV_inp) annotation (Line(points={{-69.2,-108},{
            18,-108},{18,-59},{27.7143,-59}}, color={0,0,127}));
    connect(nuScaleModule_v5_TBP.RxT_Power, switch3.u3) annotation (Line(points=
           {{-69.625,-47.6923},{-108,-47.6923},{-108,-48},{-138,-48},{-138,
            -130.4},{-120.4,-130.4}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
              -160},{220,120}})),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,
              120}})),
      experiment(
        StopTime=1210000,
        Interval=100,
        Tolerance=1e-05,
        __Dymola_Algorithm="Esdirk45a"));
  end PowerPlant_NPIC_TBP;

  model PowerPlant_w_bypass
    Reactor.NuScaleModule_v5 nuScaleModule_v5_1
      annotation (Placement(transformation(extent={{-86,-70},{-42,-20}})));
    NHES.Systems.PrimaryHeatSystem.SMR_Generic.Components.Data.Data_GenericModule
                                       data(length_steamGenerator_tube=36)
      annotation (Placement(transformation(extent={{174,42},{190,58}})));
    Modelica.Blocks.Interfaces.RealInput Reactivity
      annotation (Placement(transformation(extent={{-194,68},{-154,108}})));
    Modelica.Blocks.Interfaces.RealInput FWP_input
      annotation (Placement(transformation(extent={{202,70},{170,102}}),
          iconTransformation(extent={{202,70},{170,102}})));
    Modelica.Blocks.Sources.Constant const(k=557.3)
      annotation (Placement(transformation(extent={{-180,8},{-160,28}})));
    Modelica.Blocks.Sources.Constant const1(k=3.39e+06)
      annotation (Placement(transformation(extent={{98,42},{84,56}})));
    TRANSFORM.Controls.P_Control p_Control(k=0.005)
      annotation (Placement(transformation(extent={{-144,8},{-124,28}})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{8,-8},{-8,8}},
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
      yMin=0) annotation (Placement(transformation(extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={64,12})));
    BOP.NuScaleBOP_w_bypass BOP_mdot
      annotation (Placement(transformation(extent={{36,-80},{120,-10}})));
    Modelica.Blocks.Sources.Constant const3(k=53)
      annotation (Placement(transformation(extent={{78,-94},{90,-82}})));
  equation
    connect(p_Control.y, nuScaleModule_v5_1.CR_reactivity) annotation (Line(
          points={{-123,18},{-70,18},{-70,-26},{-71.15,-26},{-71.15,-30}},
                                                                color={0,0,127}));
    connect(nuScaleModule_v5_1.Core_Tavg, p_Control.u_m) annotation (Line(
          points={{-70.7375,-34.4231},{-134,-34.4231},{-134,6}},         color=
            {0,0,127}));
    connect(const.y, p_Control.u_s) annotation (Line(points={{-159,18},{-146,18}},
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
            -51.4875,-38.2692},{30,-38.2692},{30,-42.7727},{45.52,-42.7727}},
          color={0,127,255}));
    connect(nuScaleModule_v5_1.port_b, BOP_mdot.port_b) annotation (Line(points={{
            -51.4875,-68.2692},{-50,-68.2692},{-50,-76},{30,-76},{30,-56.4545},
            {45.24,-56.4545}},
          color={0,127,255}));
    connect(PID.y, BOP_mdot.T_valve1) annotation (Line(points={{64,3.2},{64,-8},
            {37.4,-8},{37.4,-27.5}},     color={0,0,127}));
    connect(switch1.u3, const1.y) annotation (Line(points={{8.4,47.6},{64,47.6},
            {64,49},{83.3,49}}, color={0,0,127}));
    connect(switch1.u1, nuScaleModule_v5_1.SG_press) annotation (Line(points={{-4.4,
            47.6},{-54.5125,47.6},{-54.5125,-26.7308}},      color={0,0,127}));
    connect(BOP_mdot.FW_Pump, const3.y) annotation (Line(points={{94.1,-64.8864},
            {126,-64.8864},{126,-88},{90.6,-88}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
              -160},{220,120}})),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,
              120}})),
      experiment(
        StopTime=1210000,
        Interval=100,
        Tolerance=1e-05,
        __Dymola_Algorithm="Esdirk45a"));
  end PowerPlant_w_bypass;
end PowerPlant_Models;
