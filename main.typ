#import "lab-report.typ": lab-report

// create title page and initialize all of the formating
#show: lab-report.with(
  title: "Heat Pump",
  authors: ("Raul Wagner", "Martin Kronberger"),
  supervisor: "Someone",
  groupnumber: "301",
  date: datetime(day: 8, month: 5, year: 2025),
)

= Calibration of the powersource

1. Start the powersource and wait for 15 minutes until it is warmed up.
2. Switch of all other devices connected to the powersource.
3. Start the LabView Program for monitoring the measurment values.
4. Adjust the reading of the powersource, by turning the potentiometer besides the readout display, until the LabView program shows approximately 0.0 W.

= Determining the performance number at different modes of operation

- At every mode of operation the heat pump was running around 20 minutes.
- The heating coil is submerged in 4.5 litres of water at ambient temperature.
- Every half minute the temperature of the warm water containers and the power consumption of the compressor is measured.

== Air at free convection

- At minute 12 the vaporizer built up ice on its surface.

== Air at forced convection (ventilation)

-

== Water

= Measurement in the heat pump cycle

- Before the measurement the vaporizer is to be dried.
