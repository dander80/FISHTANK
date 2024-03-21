within NHES.Systems.SupervisoryControl;
model InputSetpointData_Cluster
  extends BaseClasses.Partial_ControlSystem;

  parameter Real delayStart=5000 "Time to start tracking power profiles";
  parameter SI.Time timeScale=60*60 "Time scale of first table column";

  parameter SI.Power W_nominal_BOP = 4.13285e8 "Nominal BOP Power";
  parameter SI.Power W_nominal_IP = 51.1454e6 "Nominal IP Power";
  parameter SI.Power W_nominal_ES = 0 "Nominal ES Power";
  parameter SI.Power W_nominal_SES = 35e6 "Nominal SES Power";

  output SI.Power W_totalSetpoint_BOP = switch_BOP.y annotation(Dialog(group="Outputs",enable=false));
  output SI.Power W_totalSetpoint_IP = switch_IP.y annotation(Dialog(group="Outputs",enable=false));
  output SI.Power W_totalSetpoint_ES = switch_ES.y annotation(Dialog(group="Outputs",enable=false));
  output SI.Power W_totalSetpoint_SES = switch_SES.y annotation(Dialog(group="Outputs",enable=false));
  output SI.Power W_totalSetpoint_EG = switch_EG.y annotation(Dialog(group="Outputs",enable=false));

  Modelica.Blocks.Sources.CombiTimeTable demand_BOP(
    tableOnFile=true,
    startTime=delayStart,
    tableName="BOP",
    timeScale=timeScale,
    fileName=fileName)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Logical.LessThreshold greaterEqualThreshold1(threshold=
        delayStart)
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Logical.Switch switch_BOP
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Modelica.Blocks.Sources.Constant nominal_BOP(k=W_nominal_BOP)
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));

  Modelica.Blocks.Sources.CombiTimeTable demand_ES(
    tableOnFile=true,
    startTime=delayStart,
    tableName="ES",
    timeScale=timeScale,
    fileName=fileName)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Logical.Switch switch_ES
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Constant nominal_ES(k=W_nominal_ES)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.CombiTimeTable demand_SES(
    tableOnFile=true,
    startTime=delayStart,
    tableName="SES",
    timeScale=timeScale,
    fileName=fileName)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Logical.Switch switch_SES
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Sources.Constant nominal_SES(k=W_nominal_SES)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.ContinuousClock clock(offset=0, startTime=0)
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));

  Modelica.Blocks.Sources.CombiTimeTable demand_EG(
    tableOnFile=true,
    startTime=delayStart,
    timeScale=timeScale,
    tableName="NetDemand",
    fileName=fileName)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Logical.Switch switch_EG
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.Blocks.Sources.Constant nominal_EG(k=nominal_BOP.k + nominal_ES.k +
        nominal_SES.k - nominal_IP.k)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.CombiTimeTable demand_IP(
    tableOnFile=true,
    startTime=delayStart,
    timeScale=timeScale,
    tableName="IP",
    fileName=fileName)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Logical.Switch switch_IP
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Sources.Constant nominal_IP(k=W_nominal_IP)
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  parameter String fileName="./timeSeriesData.txt"
    "File where matrix is stored";
equation
  connect(demand_BOP.y[1], switch_BOP.u3) annotation (Line(points={{-59,90},{
          -48,90},{-48,102},{-42,102}}, color={0,0,127}));
  connect(nominal_BOP.y, switch_BOP.u1) annotation (Line(points={{-59,130},{-48,
          130},{-48,118},{-42,118}}, color={0,0,127}));
  connect(demand_ES.y[1], switch_ES.u3) annotation (Line(points={{-59,10},{-48,
          10},{-48,22},{-42,22}}, color={0,0,127}));
  connect(nominal_ES.y, switch_ES.u1) annotation (Line(points={{-59,50},{-48,50},
          {-48,38},{-42,38}}, color={0,0,127}));
  connect(demand_SES.y[1], switch_SES.u3) annotation (Line(points={{-59,-70},{
          -48,-70},{-48,-58},{-42,-58}}, color={0,0,127}));
  connect(nominal_SES.y, switch_SES.u1) annotation (Line(points={{-59,-30},{-48,
          -30},{-48,-42},{-42,-42}}, color={0,0,127}));
  connect(greaterEqualThreshold1.y, switch_ES.u2)
    annotation (Line(points={{-99,30},{-90,30},{-42,30}},
                                                 color={255,0,255}));
  connect(clock.y, greaterEqualThreshold1.u)
    annotation (Line(points={{-139,30},{-122,30}},           color={0,0,127}));
  connect(switch_BOP.u2, switch_ES.u2) annotation (Line(points={{-42,110},{-90,
          110},{-90,30},{-42,30}}, color={255,0,255}));
  connect(switch_SES.u2, switch_ES.u2) annotation (Line(points={{-42,-50},{-90,
          -50},{-90,30},{-42,30}}, color={255,0,255}));
  connect(nominal_EG.y, switch_EG.u1) annotation (Line(points={{21,10},{30,10},
          {30,-2},{38,-2}}, color={0,0,127}));
  connect(demand_EG.y[1], switch_EG.u3) annotation (Line(points={{21,-30},{30,-30},
          {30,-18},{38,-18}}, color={0,0,127}));
  connect(switch_EG.u2, switch_ES.u2) annotation (Line(points={{38,-10},{-90,-10},
          {-90,30},{-42,30}}, color={255,0,255}));
  connect(nominal_IP.y, switch_IP.u1) annotation (Line(points={{21,90},{30,90},{
          30,78},{38,78}},  color={0,0,127}));
  connect(switch_IP.u2, switch_ES.u2) annotation (Line(points={{38,70},{-90,70},
          {-90,30},{-42,30}}, color={255,0,255}));
  connect(demand_IP.y[1], switch_IP.u3) annotation (Line(points={{21,50},{30,50},
          {30,62},{38,62}}, color={0,0,127}));
annotation(defaultComponentName="SC", experiment(StopTime=3600,
        __Dymola_NumberOfIntervals=3600),
    Diagram(coordinateSystem(extent={{-160,-100},{160,180}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
                  Text(
          extent={{-94,82},{94,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,237},
          fillPattern=FillPattern.Solid,
          textString="Input Setpoints: Modelica Path")}));
end InputSetpointData_Cluster;