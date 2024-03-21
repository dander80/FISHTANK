within NHES.Electrolysis.HeatExchangers.BaseClasses.LooselyCoupled;
model HEX_cathodeGasRecup_ROM_nom_NHES_notUsed
  "Nominal condition for heat recuperation via cathode gas"

  import      Modelica.Units.SI;
  import gasProperties = Modelica.Media.IdealGases.Common.SingleGasesData;

  // ---------- Fluid packages -------------------------------------------------
  replaceable package Medium_tube =
      Modelica.Media.Water.StandardWater                               constrainedby
    Modelica.Media.Interfaces.PartialPureSubstance
    "Working fluid model in tube side of a heat exchanger";
  replaceable package Medium_shell =
      Electrolysis.Media.Electrolysis.CathodeGas constrainedby
    Modelica.Media.Interfaces.PartialMedium
    "Working fluid model in shell side of a heat exchanger";

  // ---------- Define constants -----------------------------------------------
  constant Modelica.Media.IdealGases.Common.DataRecord
    dataH2=gasProperties.H2;
  constant Modelica.Media.IdealGases.Common.DataRecord
    dataH2O=gasProperties.H2O;
  constant SI.MolarMass mwH2O = gasProperties.H2O.MM
    "Molecular weight of water or steam [kg/mol]";
  constant SI.MolarMass mwH2 = gasProperties.H2.MM
    "Molecular weight of hydrogen [kg/mol]";

  // ---------- Define parameters ----------------------------------------------
  parameter SI.Volume Vf = 0.01 "Fluid internal volume [m3]";
  parameter SI.Volume Vm = 0.35 + 1.7 + 0.55
    "Volume of the metal parts in heat exchanger [m3]";
  parameter SI.Density rhom = 7753 "Metal density [kg/m3]";
  parameter SI.SpecificHeatCapacity cpm = 486
    "Specific heat capacity of the metal [J/(kg.K)]";
  parameter Electrolysis.Types.HydraulicConductanceSquared coeff_dpTube=
      4872.23324354983
    "Coefficient for the pressure drop in tube side [Pa.s2/(kg2)]";
  parameter Electrolysis.Types.HydraulicConductanceSquared coeff_dpShell=
      1988.79877672254
    "Coefficient for the pressure drop in shell side [Pa.s2/(kg2)]";

  parameter SI.MoleFraction yH2Shell_start = 0.82
    "Start value of H2 mole fraction in shell side" annotation (Dialog(tab="Initialisation"));
  final parameter SI.MoleFraction yShell_start[:]={yH2Shell_start,1 -
      yH2Shell_start} "Start value of mole fractions in shell side {H2, H2O}";
  final parameter SI.MassFraction XShell_start[:]=
      Electrolysis.Utilities.moleToMassFractions(yShell_start, {mwH2*1000,
      mwH2O*1000}) "Start value of mass fractions in shell side {H2, H2O}";

  SI.Temperature Tm "Metal temperature [K]";

  SI.Power QTube_gained "Energy gained by the cold fluid [W]";
  SI.Power QShell_lost "Energy lost by the hot fluid [W]";

  SI.Pressure pTube_in( min=0) "Inlet pressure of the medium in tube side [Pa]";
  SI.Pressure pShell_in( min=0)
    "Inlet pressure of the medium in shell side [Pa]";
  SI.Pressure pTube_out( min=0)
    "Outlet pressure of the medium in tube side [Pa]";
  SI.Pressure pShell_out( min=0)
    "Outlet pressure of the medium in shell side [Pa]";

  SI.SpecificEnthalpy hTube_in(min = 0)
    "Inlet specific enthalpy of the medium in tube side [J/kg]";
  SI.SpecificEnthalpy hShell_in(min = 0)
    "Inlet specific enthalpy of the medium in shell side [J/kg]";
  SI.SpecificEnthalpy hTube_out(min = 0)
    "Outlet specific enthalpy of the medium in tube side [J/kg]";
  SI.SpecificEnthalpy hShell_out(min = 0)
    "Outlet specific enthalpy of the medium in shell side [J/kg]";

  SI.Temperature TTube_in(min=273.15,nominal=25+273.15);
  SI.Temperature TTube_out(min=273.15,start=273.15 + 210);
  SI.Temperature TShell_in(min=273.15,nominal=750+273.15);
  SI.Temperature TShell_out(min=273.15, start=273.15+335);
  SI.Temperature TTube_mean(min=273.15);
  SI.Temperature TShell_mean(min=273.15);

  SI.MassFraction XShell_in[Medium_shell.nX](min={0,0}, max={1,1}, start=XShell_start);
  SI.MassFraction XShell_out[Medium_shell.nX](min={0,0},max={1,1}, start=XShell_start);

  SI.MassFlowRate wTube_in(min=0)
    "Inlet mass flow rate of the medium in tube side [kg/s]";
  SI.MassFlowRate wTube_out(min=0)
    "Outlet mass flow rate of the medium in tube side [kg/s]";
  SI.MassFlowRate wShell_in(min=0)
    "Inlet mass flow rate of the medium in shell side [kg/s]";
  SI.MassFlowRate wShell_out(min=0)
    "Outlet mass flow rate of the medium in shell side [kg/s]";

  SI.ThermalConductance AhTube "Thermal conductance in tube side [W/K]";
  SI.ThermalConductance AhShell "Thermal conductance in shell side [W/K]";

  SI.Pressure dpTube "Pressure drop in tube side [Pa]";
  SI.Pressure dpShell "Pressure drop in shell side [Pa]";

  Medium_tube.ThermodynamicState tubeState_in;
  Medium_shell.ThermodynamicState shellState_in;
  Medium_tube.ThermodynamicState tubeState_out;
  Medium_shell.ThermodynamicState shellState_out;

equation
  // ----------- Fluid properties ----------------------------------------------
  tubeState_in = Medium_tube.setState_pT(pTube_in, TTube_in);
  shellState_in = Medium_shell.setState_pTX(pShell_in, TShell_in, XShell_in);
  tubeState_out = Medium_tube.setState_pT(pTube_out, TTube_out);
  shellState_out = Medium_shell.setState_pTX(pShell_out, TShell_out, XShell_out);

  wTube_in = 4.484656329;
  wShell_in = 1.354150176;

  pTube_in = 2.10199104874786*1e6 "[Pa]";
  pShell_in = 1.964*1e6 "[Pa]";

  Tm = (TTube_mean + TShell_mean)/2;
  TTube_mean = (TTube_in + TTube_out)/2;
  TShell_mean = (TShell_in + TShell_out)/2;

  QTube_gained = -(wTube_in*hTube_in - wTube_out*hTube_out);
  QShell_lost = (wShell_in*hShell_in - wShell_out*hShell_out);

  dpTube = coeff_dpTube*wTube_in^2;
  dpShell = coeff_dpShell*wShell_in^2;

  // Pressure drop across the heat exchanger
  pTube_out = pTube_in - dpTube;
  pShell_out = pShell_in - dpShell;

  // ----- Mass balances ------
  0 = wTube_in - wTube_out;
  0 = wShell_in - wShell_out;

  // ----- Independent component mass balances -----
  XShell_in = XShell_start;
  XShell_out = XShell_start;

  // ----- Energy balances ------
  hTube_in = Medium_tube.specificEnthalpy(tubeState_in);
  hShell_in = Medium_shell.specificEnthalpy(shellState_in);
  hTube_out = Medium_tube.specificEnthalpy(tubeState_out);
  hShell_out = Medium_shell.specificEnthalpy(shellState_out);

  TTube_in = 273.15 + 25;
  TShell_in = 273.15 + 750;

  QTube_gained = 3.515001996e6;
  //TTube_out = 273.15 + 210;
  //TShell_out = 273.15 + 320;

  AhTube*(Tm - TTube_mean) = QTube_gained;
  AhShell*(Tm - TShell_mean) = -QShell_lost;
  //Vm*rhom*cpm*der(Tm) = (wTube_in*hTube_in - wTube_out*hTube_out) + (wShell_in*hShell_in - wShell_out*hShell_out);
  0 = (wTube_in*hTube_in - wTube_out*hTube_out) + (wShell_in*hShell_in - wShell_out*hShell_out);

    annotation (
     Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Sphere,
          fillColor={238,46,47}),
        Text(
          extent={{-100,-115},{100,-145}},
          lineColor={85,170,255},
          textString="%name"),
        Line(
          points={{-6.12323e-015,100},{0,40},{40,20},{-40,-20},{0,-40},{6.12323e-015,
              -100}},
          color={0,0,255},
          thickness=0.5,
          origin={0,0},
          rotation=90)}),
    experiment(StopTime=100, Interval=1));
end HEX_cathodeGasRecup_ROM_nom_NHES_notUsed;