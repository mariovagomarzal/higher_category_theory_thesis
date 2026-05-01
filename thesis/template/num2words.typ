/// This module provides a function to convert numbers into their English word representation.
// TODO: This module should be replaced with the remote package `num2words` once it is merged into the official Typst
// package repository:
//   https://github.com/typst/packages/pull/4720

/// English words for digits 0–9.
#let _units = (
  "zero",
  "one",
  "two",
  "three",
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine",
)

/// English words for numbers 10–19.
#let _teens = (
  "ten",
  "eleven",
  "twelve",
  "thirteen",
  "fourteen",
  "fifteen",
  "sixteen",
  "seventeen",
  "eighteen",
  "nineteen",
)

/// Converts an integer (0–19) to its English word representation.
///
/// -> str
#let num2words(
  /// The number to convert. Must be between 0 and 19.
  /// -> int
  number,
) = {
  if number < 10 {
    _units.at(number)
  } else if number < 20 {
    _teens.at(number - 10)
  } else {
    panic("num2words: only supports numbers from 0 to 19 are supported, got " + number)
  }
}
