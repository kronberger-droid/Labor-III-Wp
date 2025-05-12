#import "lab-report.typ": lab-report
#import "@preview/lilaq:0.2.0" as lq
#import calc: round

#show: lab-report.with(
  title: "Heat Pump",
  authors: ("Raul Wagner", "Martin Kronberger"),
  supervisor: "Someone",
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
      temperature_A: columns.at(1),
      temperature_B: columns.at(2),
      temperature_C: columns.at(3),
      temperature_D: columns.at(4),
      power: columns.at(5),
    )
  })
}

#let parse_table(path) = {
  let lines = read(path).split("\n").slice(0, -1)
  lines.map(line => {
    let columns = line
      .split("\t")
      .map(x => x.replace(",", ".").trim())
      .filter(x => x != "")
      .map(x => float(x))
    (
      temperature_A: columns.at(0),
      temperature_B: columns.at(1),
      temperature_C: columns.at(2),
      temperature_D: columns.at(3),
      pressure_A: columns.at(4),
      pressure_B: columns.at(5),
    )
  })
}

#let power_number(data, heat_capacity, mass) = {
  let delta_T = data.last().temperature_A - data.first().temperature_A
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

= Preparation before measurement

1. Start the powersource and wait for 15 minutes until it is warmed up.
2. Switch of all other devices connected to the powersource.
3. Start the LabView Program for monitoring the measurment values.
4. Adjust the reading of the powersource, by turning the potentiometer besides the readout display, until the LabView program shows approximately 0.0 W.

= Determining the performance number at different modes of operation <performance_factor>

- At every mode of operation the heat pump was running around 20 minutes.
- The heating coil is submerged in 4.5 litres of water at ambient temperature.
- Every half minute the temperature of the warm water containers and the power consumption of the compressor is measured.
- Before every measurement the vaporizer is to be dried.

== Air at free convection

- At minute 12 the vaporizer built up ice on its surface.

#let data_air = parse_measurements("data/Luft.lvm")

#let power_number_air = round(
  power_number(data_air, heat_capacity, mass),
  digits: 1,
)

#figure(lq.diagram(
  width: 12cm,
  height: 6cm,
  title: [Temperature at different sections of the heat pump],
  xlabel: [time $t$ in min],
  ylabel: [temperature $T$ in C$degree$],
  lq.plot(
    data_air.map(x => x.time / 60),
    data_air.map(y => y.temperature_A),
    mark: none,
  ),
  lq.plot(
    data_air.map(x => x.time / 60),
    data_air.map(y => y.temperature_B),
    mark: none,
  ),
  lq.plot(
    data_air.map(x => x.time / 60),
    data_air.map(y => y.temperature_C),
    mark: none,
  ),
  lq.plot(
    data_air.map(x => x.time / 60),
    data_air.map(y => y.temperature_D),
    mark: none,
  ),
))

With the power factor of #power_number_air

== Air at forced convection (ventilation)

#let data_ventilation = parse_measurements("data/Ventilator.lvm")

#let power_number_ventilation = round(
  power_number(data_ventilation, heat_capacity, mass),
  digits: 1,
)

#figure(lq.diagram(
  width: 12cm,
  height: 6cm,
  title: [Temperature at different sections of the heat pump],
  xlabel: [time $t$ in min],
  ylabel: [temperature $T$ in C$degree$],
  lq.plot(
    data_ventilation.map(x => x.time / 60),
    data_ventilation.map(y => y.temperature_A),
    mark: none,
  ),
  lq.plot(
    data_ventilation.map(x => x.time / 60),
    data_ventilation.map(y => y.temperature_B),
    mark: none,
  ),
  lq.plot(
    data_ventilation.map(x => x.time / 60),
    data_ventilation.map(y => y.temperature_C),
    mark: none,
  ),
  lq.plot(
    data_ventilation.map(x => x.time / 60),
    data_ventilation.map(y => y.temperature_D),
    mark: none,
  ),
))

With the power factor of #power_number_ventilation

== Water

#let data_water = parse_measurements("data/Wasser.lvm")

#let power_number_water = round(
  power_number(data_water, heat_capacity, mass),
  digits: 1,
)

#figure(lq.diagram(
  width: 12cm,
  height: 6cm,
  title: [Temperature at different sections of the heat pump],
  xlabel: [time $t$ in min],
  ylabel: [temperature $T$ in C$degree$],
  lq.plot(
    data_water.map(x => x.time / 60),
    data_water.map(y => y.temperature_A),
    mark: none,
  ),
  lq.plot(
    data_water.map(x => x.time / 60),
    data_water.map(y => y.temperature_B),
    mark: none,
  ),
  lq.plot(
    data_water.map(x => x.time / 60),
    data_water.map(y => y.temperature_C),
    mark: none,
  ),
  lq.plot(
    data_water.map(x => x.time / 60),
    data_water.map(y => y.temperature_D),
    mark: none,
  ),
))


With the power factor of #power_number_water

= Measurement in the heat pump cycle

- Where in the cycle does the highest temperature occur, and what is its value?
- What is the maximum possible coefficient of performance ($epsilon_i$) according to Section 2.4? Compare it with the coefficient of performance measured in @performance_factor and with the Carnot coefficient of performance ($epsilon_c$).
- What proportion of the working medium is in the gas phase after exiting the expansion valve?

#let table_data = parse_table("data/Kreislauf_only.lvm")

#let means = (
  table_data
    .fold(table_data.first().values(), (
      acc,
      item,
    ) => acc.zip(item.values()).map(row => row.sum()))
    .map(sum => sum / table_data.len())
)

#table(
  columns: 6,
  align: center,
  [Temperature A], [Temperature A], [Temperature A], [Temperature A], [Pressure A], [Pressure B],
  ..means.map(value => str(round(value, digits: 1))),
)

