#import "lab-report.typ": lab-report
#import "@preview/lilaq:0.2.0" as lq
#import calc: round

#show: lab-report.with(
  title: "Heat Pump",
  authors: ("Raul Wagner", "Martin Kronberger"),
  supervisor: "Maximilian Keckeis",
  groupnumber: "301",
  date: datetime(day: 8, month: 5, year: 2025),
)

#set heading(numbering: "1.1")

#let parse_measurements(path) = {
  let lines = read(path).split("\n").slice(1, -1)
  lines.map(line => {
    let columns = line
      .split("\t")
      .map(x => x.replace(",", ".").trim())
      .filter(x => x != "")
      .map(x => float(x))
    (
      time: columns.at(0),
      temperature_2: columns.at(1),
      temperature_1: columns.at(2),
      temperature_A: columns.at(3),
      temperature_D: columns.at(4),
      power: columns.at(5),
    )
  })
}

#let parse_table(path) = {
  let lines = read(path).split("\n").slice(0, -1)
  let result = lines.map(line => {
    let columns = line
      .split("\t")
      .map(x => x.replace(",", ".").trim())
      .filter(x => x != "")
      .map(x => float(x))
    columns
  })
  result
}

#let power_number(data, heat_capacity, mass) = {
  let delta_T = data.last().temperature_2 - data.first().temperature_2
  let work = data
    .windows(2)
    .map(win => {
      let delta_t = win.last().time - win.first().time
      let power = (win.last().power + win.first().power) / 2
      delta_t * power
    })
    .sum()
  (delta_T * mass * heat_capacity) / work
}

#let heat_capacity = 4.19e3 // in J/(kg K)
#let mass = 4.5 // in kg

= Experimental Setup

The experimental setup consists of a Compression Heat Pump System filled with R 12 ($"CCl"_2"F"_2$).

The compressor of the system has a energy consumption of approximately 130 W which is monitored by an electrical power meter. A coiled copper tube forms the condenser. Placed in a bucket with 4.5l water it warms up the water in every experiment, monitored trough a PT100 temperature meter in the water. A submersible pump is used to mix the water in the bucket permanently. On the opposite side of the cycle the evaporator also consists of a coiled copper tube and the temperature near the coil is measured by another PT100. Unlike the condenser the evaporator is not permanently submerged in water. It has to be mentioned that it was physically possible for the temperature meters in the water to touch the copper coils since the water was stirred continuously. This can cause measuring errors. Two different pressure gauges, for the low and high pressure side, show the pressure of their side from -1 to 10 bar and from -1 to 30 bar. The collector filters the air out of the medium and supplies the expansion valve only with liquid. At the expansion valve the pressure drops from the high to the low pressure. A pressure switch on the high pressure side switches off the compressor if the pressure exceeds 16 bar.

#figure(
  image("assets/heat_pump_setup.png", width: 10cm),
  caption: [
    Heat pump setup including the following components \
    (1): compressor , (2): condenser with temperature $T_2$, (3): pressure gauge showing pressure $P_2$, (4): collector, (5): expansion valve, (6) evaporator with temperature $T_1$, (7): pressure gauge showing pressure $P_1$
  ]
)

== Measurements and error estimation
The temperatures are measured near the condenser and evaporator coil and directly at their copper pipes in order to monitor the temperatures of both pressure sides and the heated and cooled water. The four PT100  resistance thermometers are connected in series and supplied with 1 mA by a power source. 
The error of the linearity between resistance and temperature is estimated with ±3%.
$
delta 𝑇 = plus.minus 0, 03(𝑇 − 27, 781𝐾)
$
Since the error increases with the temperature the maximum error is expected at the highest
temperature.

The used electrical energy is measured with an electrical power meter, which was calibrated with an accuracy of $plus.minus$1 W.

The pressure gauges are analog and have to be read manually. Therefore the error of the low pressure gauge is $plus.minus$0.2 bar and of the high pressure gauge is $plus.minus$0.1 bar.

The monitoring of the temperature was carried out digitally via a LabView program.

The water used to be heated and cooled was filled manually using a gauge. The error of the mass was $plus.minus$0.5 kg.

== Preparation before measurement

1. Start the power meter and wait for 15 minutes until it is warmed up.
2. Switch off all other devices connected to the powersource.
3. Start the LabView Program for monitoring the measurment values.
4. Adjust the reading of the powersource, by turning the potentiometer besides the readout display, until the LabView program shows approximately 0.0 W.

= Determining the performance number at different modes of operation <performance_factor>

- At every mode of operation the heat pump was running around 20 minutes.
- The condenser is submerged in 4.5 litres of water at ambient temperature, and the water is circulated constantly by a submersible pump.
- Before every measurement the vaporizer is to be dried.
- The vaporizer coil will be surrounded in different mediums for every measurement.
- Every 15 seconds the temperature of the warm water containers and the power consumption of the compressor is measured.
- After the measurement the power factor will be calculated using the following formula:
$
  epsilon = Q / W = (m c_V Delta T)/ (integral P d s)
$
With $c_V = 4.19 "kJ" / "kg K"$, m = 4.5l
== Air at free convection

- The System was at room temperature, including the water around the condenser.
- The measuring process in the LabView program was started. Simultaneously the compressor and the submersible pump in the condenser bucket were switched on.
- At minute 12 the vaporizer built up ice on its surface.
- After 20 minutes the measurement was stopped by switching off the compressor and the pump.

#let data_air = parse_measurements("data/Luft.lvm")

#let power_number_air = round(
  power_number(data_air, heat_capacity, mass),
  digits: 1,
)

#figure(lq.diagram(
  width: 12cm,
  height: 6cm,
  title: [Temperature measurements with air surrounding the evaporator],
  xlabel: [Time $t$ in min],
  ylabel: [Temperature $T$ in C$degree$],
  yaxis: (mirror: false),
  lq.plot(
    data_air.map(x => x.time / 60),
    data_air.map(y => y.temperature_2),
    mark: none,
    label: $T_2$,
  ),
  lq.plot(
    data_air.map(x => x.time / 60),
    data_air.map(y => y.temperature_1),
    mark: none,
    label: $T_1$,
  ),
  lq.plot(
    data_air.map(x => x.time / 60),
    data_air.map(y => y.temperature_A),
    mark: none,
    label: $T_A$
  ),
  lq.plot(
    data_air.map(x => x.time / 60),
    data_air.map(y => y.temperature_D),
    mark: none,
    label: $T_D$
  ),
  lq.yaxis(
    position: right,
    label: [Power P in W],
    lq.plot(
      data_air.map(x => x.time / 60),
      data_air.map(y => y.power),
      mark: none,
      label: $P$
    )
  )
))

With the power factor of:
$
  epsilon = #power_number_air plus.minus 15%
$

== Air at forced convection (ventilation)

- The System had to cool down to room temperature, including the water around the condenser.
- A Fan was installed to ventilate the evaporator. The power used by the fan was also monitored by the electrical power meter
- The measuring process in the LabView program was started. Simultaneously the compressor, the fan and the submersible pump in the condenser bucket were switched on. 
- At minute 10 the vaporizer built up ice on its surface.
- After 20 minutes the measurement was stopped by switching off the compressor, the fan and the pump.

#let data_ventilation = parse_measurements("data/Ventilator.lvm")

#let power_number_ventilation = round(
  power_number(data_ventilation, heat_capacity, mass),
  digits: 1,
)

#figure(lq.diagram(
  width: 12cm,
  height: 6cm,
  title: [Temperature measurements with air ventilated over the evaporator],
  xlabel: [Time $t$ in min],
  ylabel: [Temperature $T$ in C$degree$],
  yaxis: (mirror: false),
  lq.plot(
    data_ventilation.map(x => x.time / 60),
    data_ventilation.map(y => y.temperature_2),
    mark: none,
    label: $T_2$
  ),
  lq.plot(
    data_ventilation.map(x => x.time / 60),
    data_ventilation.map(y => y.temperature_1),
    mark: none,
    label: $T_1$
  ),
  lq.plot(
    data_ventilation.map(x => x.time / 60),
    data_ventilation.map(y => y.temperature_A),
    mark: none,
    label: $T_A$
  ),
  lq.plot(
    data_ventilation.map(x => x.time / 60),
    data_ventilation.map(y => y.temperature_D),
    mark: none,
    label: $T_D$
  ),
  lq.yaxis(
    position: right,
    label: [Power P in W],
    lq.plot(
      data_ventilation.map(x => x.time / 60),
      data_ventilation.map(y => y.power),
      mark: none,
      label: $P$
    )
  )
))

With the power factor of:
$
  epsilon = #power_number_ventilation plus.minus 15%
$

== Water

- The System had to cool down to room temperature, that also includes the temperature of the water around the condenser.
- A second bucket with water was installed around the evaporator, also continuously stirred by a submersible pump. The power used by the pump was also monitored by the electrical power meter.
- The measuring process in the LabView program was started. Simultaneously the compressor and the submersible pumps in both buckets were switched on. 
- After 20 minutes the measurement was stopped by switching off the compressor and the pumps.

#let data_water = parse_measurements("data/Wasser.lvm")

#let power_number_water = round(
  power_number(data_water, heat_capacity, mass),
  digits: 1,
)

#figure(lq.diagram(
  width: 12cm,
  height: 6cm,
  title: [Temperature measurements with water surrounding the evaporator],
  xlabel: [Time $t$ in min],
  ylabel: [Temperature $T$ in C$degree$],
  yaxis: (mirror: false),
  lq.plot(
    data_water.map(x => x.time / 60),
    data_water.map(y => y.temperature_2),
    mark: none,
    label: $T_2$
  ),
  lq.plot(
    data_water.map(x => x.time / 60),
    data_water.map(y => y.temperature_1),
    mark: none,
    label: $T_1$
  ),
  lq.plot(
    data_water.map(x => x.time / 60),
    data_water.map(y => y.temperature_A),
    mark: none,
    label: $T_A$
  ),
  lq.plot(
    data_water.map(x => x.time / 60),
    data_water.map(y => y.temperature_D),
    mark: none,
    label: $T_D$
  ), 
  lq.yaxis(
    position: right,
    label: [Power P in W],
    lq.plot(
      data_water.map(x => x.time / 60),
      data_water.map(y => y.power),
      mark: none,
      label: $P$
    )
  )
))


With the power factor of:
$
  epsilon = #power_number_water plus.minus 15%
$

= Measurement in the heat pump cycle

- The System had to cool down to room temperature, including the temperature of the water around condenser and evaporator.
- The condenser and evaporator were both kept in water. The experiment setup was identical to the one measuring with water around the evaporator.
- From the previous experiment we determined that the greates difference in temperature change occured around 30°C. 
- The measuring process in the LabView program was started. Simultaneously the compressor and the submersible pumps were switched on. 
- When $T_D$ reached 30°C the pressures of the low and high pressure sides were written down and the measurement was stopped.
- By refilling the bucket with cold water the system was cooled down again until it reached room temperature.
- This process was repeated four times, to have an average value for the system.
#let table_data = parse_table("data/Kreislauf_only.lvm")

#let means = table_data.reduce(
  (acc, row) =>
    acc.zip(row).map(row => row.sum())
).map(
  entry =>
    entry / table_data.len()
)



#figure(
  image("assets/enthalpy_diagram.png", width: 14cm),
  caption: [Mollier-Diagram including heat pump cycle]
)
#align(center)[
#figure(
  table(
  columns: 6,
  align: center,
  [Temperature \ $T_2$], [Temperature \ $T_1$], [Temperature \ $T_A$], [Temperature \ $T_D$], [Pressure \ $P_1$], [Pressure \ $P_2$],
  ..means.map(value => str(round(value, digits: 1))),
), caption: [Table of mean values of the four heat pump cycle measurements. With relative errors of 5% for temperature values and 4.5% for pressure values])
]

- Where in the cycle does the highest temperature occur, and what is its value?
The highest temperature in the cycle occurs on the high pressure side right after the compressor at the condenser, where heat is generated by condensing the medium. The mean temperature we measured on the high pressure side was 33.5°C.

- What is the maximum possible coefficient of performance ($epsilon_i$) according to Section 2.4? Compare it with the coefficient of performance measured in @performance_factor and with the Carnot coefficient of performance ($epsilon_c$).
The maximum possible coefficient is determined by 
$
epsilon_i = (Q)/(W) = (h_B - h_D)/(h_B - h_A)
$
The ideal coefficient typically lies between the lower measured number and the Carnot coefficient. According to our Mollier-Diagram $epsilon_max$ is approximately around 5.5.

- What proportion of the working medium is in the gas phase after exiting the expansion valve?
Since Point E in the Mollier-Diagram lies at approximately 0,06 of saturated vapor, about 6% of the medium is expected to be in a gaseous state.