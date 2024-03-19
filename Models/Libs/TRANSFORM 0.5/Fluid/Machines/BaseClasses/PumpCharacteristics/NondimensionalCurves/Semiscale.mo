within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.NondimensionalCurves;
model Semiscale "Semiscale pump converted"
  //https://www.osti.gov/servlets/purl/7349779 Fig 27 pg 197
  extends PartialNonDimCurve(table_h=[0.000000, 0.9750; 0.463648, 1.0800;
  0.785398, 0.9750; 1.030377, 0.7537; 1.190290, 0.6897; 1.373401, 0.6971;
  1.570796, 0.7250; 1.768192, 0.7452; 1.951303, 0.7155; 2.111216, 0.6985;
  2.245537, 0.7012; 2.356194, 0.7500; 2.466852, 0.7622; 2.504522, 0.7495;
  2.544416, 0.7932; 2.572279, 0.8513; 2.601173, 0.9412; 2.646459, 1.0607;
  2.694073, 1.1135; 2.761086, 1.1466; 2.850136, 1.1651; 2.944197, 1.1923;
  3.141593, 1.2200; 3.338988, 1.1538; 3.522099, 1.0086; 3.682012, 0.8382;
  3.816334, 0.6585; 3.926991, 0.5000; 4.037648, 0.3323; 4.248741, 0.0000;
  4.331883,-0.1207; 4.420932,-0.1835; 4.612720,-0.3168; 4.712389,-0.3500;
  4.812058,-0.3762; 4.980755,-0.3719; 5.092895,-0.3276; 5.215232,-0.2303;
  5.355890,-0.0960; 5.497787, 0.0875; 5.819538, 0.5200; 6.283185, 0.9750],
  table_beta=[0.000000,-0.6300; 0.197396,-0.4904; 0.380506,-0.3362;
  0.540420,-0.2132; 0.674741,-0.1220; 0.732815,-0.0884; 0.785398,-0.0650;
  0.896055, 0.0305; 1.030377, 0.1324; 1.190290, 0.2328; 1.373401, 0.3077;
  1.570796, 0.3600; 1.768192, 0.3750; 1.951303, 0.3621; 2.111216, 0.3382;
  2.245537, 0.3232; 2.356194, 0.3100; 2.466852, 0.4146; 2.601173, 0.3897;
  2.761086, 0.3966; 2.944197, 0.4712; 3.141593, 0.5400; 3.338988, 0.5673;
  3.522099, 0.5603; 3.682012, 0.5662; 3.816334, 0.5793; 3.874408, 0.5414;
  3.901355, 0.5046; 3.926991, 0.4350; 3.952626, 0.4468; 3.979574, 0.4475;
  4.037648, 0.4329; 4.171969, 0.3382; 4.331883, 0.1897; 4.514993, 0.0192;
  4.712389,-0.1500; 4.909785,-0.2981; 5.092895,-0.4483; 5.252808,-0.5809;
  5.387130,-0.6829; 5.497787,-0.7200; 5.608444,-0.7622; 5.742766,-0.7941;
  5.902679,-0.7931; 6.085790,-0.7404; 6.283185,-0.6300],
  tCCF = 0.87);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Semiscale;
