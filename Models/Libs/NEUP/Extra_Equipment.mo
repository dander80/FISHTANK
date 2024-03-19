within NEUP;
package Extra_Equipment
  model decr_func
    "Function created to decrease PID output and limit TCV opening ability, **chaging from ^8 to ^2** (3.7.23)"

    Modelica.Blocks.Interfaces.RealInput min_val
      annotation (Placement(transformation(extent={{-80,28},{-40,68}})));
    Modelica.Blocks.Interfaces.RealInput time_step
      annotation (Placement(transformation(extent={{-102,-20},{-62,20}})));
    Modelica.Blocks.Interfaces.RealInput clock
      annotation (Placement(transformation(extent={{-80,-68},{-40,-28}})));
    Modelica.Blocks.Interfaces.RealOutput mult_factor annotation (Placement(
          transformation(extent={{60,-22},{104,22}}), iconTransformation(extent={{
              60,-22},{104,22}})));
  equation
    mult_factor = min_val + (1-min_val)/sqrt(1+(clock/time_step)^2);
    annotation (Diagram(graphics={Ellipse(extent={{-62,60},{60,-62}}, lineColor={28,
                108,200})}), Icon(graphics={Ellipse(
            extent={{-62,60},{60,-62}},
            lineColor={28,108,200},
            fillColor={102,44,145},
            fillPattern=FillPattern.Solid)}));
  end decr_func;

end Extra_Equipment;
