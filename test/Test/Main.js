"use strict";

const { Readable } = require("stream");

exports._readableFromBuffer = function _readableFromBuffer(buffer) {
  return Readable.from(buffer);
}
