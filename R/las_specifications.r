#' A set of function to test conformance with LAS specifications
#'
#' A set of function to test conformance with \href{http://www.asprs.org/a/society/committees/standards/LAS_1_4_r13.pdf}{LAS specification}.
#' Tools reserved to developpers and not intended to be used by regular users. The functions return TRUE
#' or FALSE by default without more information. If behavior is 'warning' functions throw a warning
#' for each fail and return FALSE if any warning TRUE otherwise. If behavior is 'stop' functions throw
#' an error for the first fail and return TRUE if 0 error. If behavior is 'vector' returns a
#' character vector with the decription of each error an never fail. Is it useful to make a detailed
#' inspection.
#'
#' @param data a data.frame or a data.table containing a point cloud
#' @param header a list containing the header of a las file
#' @param behavior character. Defines the behavior of the function. 'bool' returns TRUE or FALSE.
#' 'warning' throw a warning for each fails and return FALSE if any warning TRUE otherwise. 'vector' returns a
#' character vector of each warning but does not thrown any warning.
#'
#' @name las_specification_tools
#' @rdname las_specification_tools
NULL

error_handling_engine = function(errors, behavior)
{
  if (behavior == "vector")
    return(errors)

  if (length(errors) == 0)
    return(TRUE)

  if (behavior == "bool")
    return(FALSE)

  if (behavior == "warning")
  {
   for (error in errors)
     warning(error, call. = FALSE)
  }

  if (behavior == "stop")
  {
    stop(errors[1], call. = FALSE)
  }
}

# ==== HEADER =====


#' @export
#' @rdname las_specification_tools
is_defined_offsets = function(header, behavior = "bool")
{
  errors <- character(0)

  if (is.null(header[["X offset"]]) | is.null(header[["Y offset"]]) | is.null(header[["Z offset"]]))
    errors = append(errors, "Invalid header: offsets not defined in the header.")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_offsets = function(header, behavior = "bool")
{
  errors <- character(0)

  if (header[["X offset"]] < 0 | header[["Y offset"]] < 0 | header[["Z offset"]] < 0)
    errors = append(errors, "Invalid header: offsets cnnot be negative")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_defined_scalefactors = function(header, behavior = "bool")
{
  errors <- character(0)

  if (is.null(header[["X scale factor"]]) | is.null(header[["Y scale factor"]]) | is.null(header[["Z scale factor"]]))
    errors = append(errors, "Invalid header: Scale factor not defined in the header.")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_scalefactors = function(header, behavior = "bool")
{
  errors <- character(0)
  s      <- c(1,10,100,1000,10000)
  valid  <- c(1/s, 0.5/s, 0.25/s)

  if (!header[["X scale factor"]] %in% valid)
    errors = append(errors, paste0("Invalid header: X scale factors should be factor ten of 0.1 or 0.5 or 0.25 not ", header[["X scale factor"]]))

  if (!header[["Y scale factor"]] %in% valid)
    errors = append(errors, paste0("Invalid header: Y scale factors should be factor ten of 0.1 or 0.5 or 0.25 not ", header[["Y scale factor"]]))

  if (!header[["Z scale factor"]] %in% valid)
    errors = append(errors, paste0("Invalid header: Z scale factors should be factor ten of 0.1 or 0.5 or 0.25 not ", header[["Z scale factor"]]))

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_defined_filesourceid = function(header, behavior = "bool")
{
  errors = character(0)

  if (is.null(header[["File Source ID"]]))
    errors = append(errors, "Invalid header: File source ID not defined in the header")

  return(error_handling_engine(errors, behavior))
}


#' @export
#' @rdname las_specification_tools
is_valid_filesourceid = function(header, behavior)
{
  errors = character(0)
  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_defined_globalencoding = function(header, behavior = "bool")
{
  errors = character(0)

  if (is.null(header[["Global Encoding"]]))
    errors = append(errors, "Invalid header: Global Encoding not defined in the header")

  if (is.null(header[["Global Encoding"]][["GPS Time Type"]]))
    errors = append(errors, "Invalid header: Global Encoding GPS Time Type bit not defined in the header")

  if (is.null(header[["Global Encoding"]][["Waveform Data Packets Internal"]]))
    errors = append(errors, "Invalid header: Global Encoding Waveform Data Packets Internal bit not defined in the header")

  if (is.null(header[["Global Encoding"]][["Waveform Data Packets External"]]))
    errors = append(errors, "Invalid header: Global Encoding Waveform Data Packets External bit not defined in the header")

  if (is.null(header[["Global Encoding"]][["Synthetic Return Numbers"]]))
    errors = append(errors, "Invalid header: Global Encoding Synthetic Return Numbers bit not defined in the header")

  if (is.null(header[["Global Encoding"]][["WKT"]]))
    errors = append(errors, "Invalid header: Global Encoding WKT bit not defined in the header")

  if (is.null(header[["Global Encoding"]][["Aggregate Model"]]))
    errors = append(errors, "Invalid header: Global Encoding Aggregate Model bit not defined in the header")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_globalencoding = function(header, behavior = "bool")
{
  errors <- character(0)

  is.bool = function(x) return(is.logical(x) & length(x) == 1L)

  if (!is.bool(header[["Global Encoding"]][["GPS Time Type"]]))
    errors = append(errors, "Invalid header: Global Encoding GPS Time Type bit is not a boolean")

  if (!is.bool(header[["Global Encoding"]][["Waveform Data Packets Internal"]]))
    errors = append(errors, "Invalid header: Global Encoding Waveform Data Packets Internal bit is not a boolean")

  if (!is.bool(header[["Global Encoding"]][["Waveform Data Packets External"]]))
    errors = append(errors, "Invalid header: Global Encoding Waveform Data Packets External bit is not a boolean")

  if (!is.bool(header[["Global Encoding"]][["Synthetic Return Numbers"]]))
    errors = append(errors, "Invalid header: Global Encoding Synthetic Return Numbers bit is not a boolean")

  if (!is.bool(header[["Global Encoding"]][["WKT"]]))
    errors = append(errors, "Invalid header: Global Encoding WKT bit is not a boolean")

  if (!is.bool(header[["Global Encoding"]][["Aggregate Model"]]))
    errors = append(errors, "Invalid header: Global Encoding Aggregate Model bit is not a boolean")

  return(error_handling_engine(errors, behavior))
}


#' @export
#' @rdname las_specification_tools
is_defined_version = function(header, behavior = "bool")
{
  errors = character(0)

  if (is.null(header[["Version Major"]]) | is.null(header[["Version Minor"]]))
    errors = append(errors, "Invalid header: Version not defined in the header")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_version = function(header, behavior = "bool")
{
  errors = character(0)

  if (header[["Version Major"]] != 1)
    errors = append(errors, "Invalid header: Version Major must be 1")

  if (!header[["Version Minor"]] %in% 1:4)
    errors = append(errors, "Invalid header: Version Minor must be 1,2,3 or 4")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_defined_date = function(header, behavior = "bool")
{
  errors = character(0)

  if (is.null(header[["File Creation Day of Year"]]) | is.null(header[["File Creation Year"]]))
    errors = append(errors, "Invalid header: File Creation date not defined in the header")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_date = function(header, behavior = "bool")
{
  errors = character(0)

  if (header[["File Creation Day of Year"]] < 0 | header[["File Creation Day of Year"]] > 366)
    errors = append(errors, "Invalid header: File Creation Day of Year invalid")

  if (header[["File Creation Year"]] < 0)
    errors = append(errors, "Invalid header: File Creation Year invalid.")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_defined_pointformat = function(header, behavior = "bool")
{
  errors = character(0)

  if (is.null(header[["Point Data Format ID"]]))
    errors = append(errors, "Invalid header: Point Data Format ID not defined in the header")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_pointformat = function(header, behavior = "bool")
{
  errors = character(0)

  if (!header[["Point Data Format ID"]] %in% 0:10)
    errors = append(errors, paste0("Invalid header: The point data format ", header[["Point Data Format ID"]], " is not part of the LAS specifications."))
  else if (header[["Point Data Format ID"]] %in% c(4,5,9,10))
    errors = append(errors, paste0("Invalid header: The point data format ", header[["Point Data Format ID"]], " is not supported yet."))

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_defined_extrabytes = function(header, behavior = "bool")
{
  errors = character(0)

  if (is.null(header$`Variable Length Records`$Extra_Bytes$`Extra Bytes Description`))
      errors = append(errors, "Invalid header: No extrabytes recorded.")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_extrabytes = function(header, behavior = "bool")
{
  errors = character(0)

  if (!is_defined_extrabytes(header))
    return(error_handling_engine(errors, behavior))

  for (extra_byte in header$`Variable Length Records`$Extra_Bytes$`Extra Bytes Description`)
  {
    if (is.null(extra_byte[["options"]]))
      errors = append(errors, "Invalid header: 'options' is missing in extra bytes description")

    if (!is.integer(extra_byte[["options"]]))
      errors = append(errors, "Invalid header: 'options' must be an integer in extra bytes description")

    if (is.null(extra_byte[["data_type"]]))
      errors = append(errors, "Invalid header: 'data_type' is missing in extra bytes description")

    if (extra_byte[["data_type"]] < 1L & extra_byte[["data_type"]] > 10L)
      errors = append(errors, "Invalid header: 'data_type' must be between 1 and 10 in extra bytes description")

    if (is.null(extra_byte[["name"]]))
      errors = append(errors, "Invalid header: 'name' is missing in extra bytes description")

    if (!is.character(extra_byte[["name"]]) | length(extra_byte[["name"]]) > 1L)
      errors = append(errors, "Invalid header: 'name' must be a string in extra bytes description")

    if (nchar(extra_byte[["name"]]) > 32L)
      errors = append(errors, "Invalid header: 'name' must be a string of length < 32 in extra bytes description")

    if (is.null(extra_byte[["description"]]))
      errors = append(errors, "Invalid header: 'description' is missing in extra bytes description")

    if (!is.character(extra_byte[["description"]]) | length(extra_byte[["description"]]) > 1L)
      errors = append(errors, "Invalid header: 'description' must be a string in extra bytes description")

    if (nchar(extra_byte[["description"]]) > 32L)
      errors = append(errors, "Invalid header: 'description' must be a string of length < 32 in extra bytes description")

    options = extra_byte[["options"]]
    options = as.integer(intToBits(options))[1:5]

    has_no_data = options[1] == 1L;
    has_min     = options[2] == 1L;
    has_max     = options[3] == 1L;
    has_scale   = options[4] == 1L;
    has_offset  = options[5] == 1L;

    if (is.null(extra_byte[["min"]]) & has_min)
      errors = append(errors, "Invalid header: 'min' is missing in extra bytes description")

    if (is.null(extra_byte[["max"]]) & has_max)
      errors = append(errors, "Invalid header: max' is missing in extra bytes description")

    if (is.null(extra_byte[["scale"]]) & has_scale)
      errors = append(errors, "Invalid header: 'scale' is missing in extra bytes description")

    if (is.null(extra_byte[["offset"]]) & has_offset)
      errors = append(errors, "Invalid header: 'offset' is missing in extra bytes description")
  }

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_empty_point_cloud = function(header, behavior = "bool")
{
  errors = character(0)

  n <- if (header[["Version Minor"]] < 4) header[["Number of points by return"]] else header[["Extended number of points by return"]]

  if (n == 0)
    errors = append(errors, "Invalid header: the header state there are 0 point in the file")

  return(error_handling_engine(errors, behavior))
}

# ==== DATA =====

#' @export
#' @rdname las_specification_tools
is_defined_coordinates = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["X"]]) | is.null(data[["Y"]]) | is.null(data[["Z"]]))
      errors = append(errors, "Invalid data: coordinates XYZ are missing")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_XYZ = function(data, behavior = "bool")
{
  errors = character(0)

  if (!is.double(data[["X"]]))
    errors = append(errors, "Invalid data: X is not of type double")

  if (!is.double(data[["Y"]]))
    errors = append(errors, "Invalid data: Y is not of type double")

  if (!is.double(data[["Z"]]))
    errors = append(errors, "Invalid data: Z is not of type double")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_Intensity = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["Intensity"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.integer(data[["Intensity"]]))
    errors = append(errors, "Invalid data: Intensity is not an unsigned integer")

  if (min(data[["Intensity"]]) < 0)
    errors = append(errors, "Invalid data: Intensity is not an unsigned integer")

  if (max(data[["Intensity"]]) > 2^16 - 1)
    errors = append(errors, "Invalid data: Intensity is not an unsigned integer on 16 bits")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_ReturnNumber = function(data, header, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["ReturnNumber"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.integer(data[["ReturnNumber"]]))
    errors = append(errors, "Invalid data: ReturnNumber is not an integer")

  if (min(data[["ReturnNumber"]]) < 1)
    errors = append(errors, "Invalid data: ReturnNumber is not an unsigned integer")

  nbits <- if (header[["Version Minor"]] < 4L) 3L else 4L

  if (max(data[["ReturnNumber"]]) > 2^nbits - 1)
    errors = append(errors, paste0("Invalid data: ReturnNumber is not an unsigned integer on ", nbits, " bits"))

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_NumberOfReturns = function(data, header, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["NumberOfReturns"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.integer(data[["NumberOfReturns"]]))
    errors = append(errors, "Invalid data: NumberOfReturns is not an integer")

  if (min(data[["NumberOfReturns"]]) < 0)
    errors = append(errors, "Invalid data: NumberOfReturns is not an unsigned integer")

  nbits <- if (header[["Version Minor"]] < 4L) 3L else 4L

  if (max(data[["NumberOfReturns"]]) > 2^nbits - 1)
    errors = append(errors, paste0("Invalid data: NumberOfReturns is not an unsigned integer on ", nbits, " bits"))

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_ScanDirectionFlag = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["ScanDirectionFlag"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.integer(data[["ScanDirectionFlag"]]))
    errors = append(errors, "Invalid data: ScanDirectionFlag is not an integer")

  if (min(data[["ScanDirectionFlag"]]) < 0)
    errors = append(errors, "Invalid data: ScanDirectionFlag is not 0 or 1")

  if (max(data[["ScanDirectionFlag"]]) > 1)
    errors = append(errors, "Invalid data: ScanDirectionFlag is not 0 or 1")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_EdgeOfFlightline = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["EdgeOfFlightline"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.integer(data[["EdgeOfFlightline"]]))
    errors = append(errors, "Invalid data: EdgeOfFlightline is not an integer")

  if (min(data[["EdgeOfFlightline"]]) < 0)
    errors = append(errors, "Invalid data: EdgeOfFlightline is not 0 or 1")

  if (max(data[["EdgeOfFlightline"]]) > 1)
    errors = append(errors, "Invalid data: EdgeOfFlightline is not 0 or 1")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_Classification = function(data, header, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["Classification"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.integer(data[["Classification"]]))
    errors = append(errors, "Invalid data: Classification is not an integer")

  if (min(data[["Classification"]]) < 0)
    errors = append(errors, "Invalid data: Classification is not an unsigned integer")

  nbits <- if (header[["Version Minor"]] < 4L) 5L else 8L

  if (max(data[["Classification"]]) > 2^nbits - 1)
    errors = append(errors, paste0("Invalid data: Classification is not an unsigned integer on ", nbits, " bits"))

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_SyntheticFlag = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["Synthetic_flag"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.logical(data[["Synthetic_flag"]]))
    errors = append(errors, "Invalid data: Synthetic_flag is not logical")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_KeypointFlag = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["Keypoint_flag"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.logical(data[["Keypoint_flag"]]))
    errors = append(errors, "Invalid data: Keypoint_flag is not logical")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_WithheldFlag = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["Withheld_flag"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.logical(data[["Withheld_flag"]]))
    errors = append(errors, "Invalid data: Withheld_flag is not logical")

  return(error_handling_engine(errors, behavior))
}


#' @export
#' @rdname las_specification_tools
is_valid_ScanAngle = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["ScanAngle"]]))
    return(error_handling_engine(errors, behavior))

  if (min(data[["ScanAngle"]]) < -90)
    errors = append(errors, "Invalid data: ScanAngle greater than -90.")

  if (max(data[["ScanAngle"]]) > 90)
    errors = append(errors, "Invalid data: ScanAngle greater than 90")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_UserData = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["UserData"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.integer(data[["UserData"]]))
    errors = append(errors, "Invalid data: UserData is not an integer")

  if (min(data[["UserData"]]) < 0)
    errors = append(errors, "Invalid data: UserData is not an unsigned integer")

  if (max(data[["UserData"]]) > 255)
    errors = append(errors, "Invalid data: UserData is not an unsigned integer on 8 bits")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_gpstime = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["gpstime"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.double(data[["gpstime"]]))
    errors = append(errors, "Invalid data: gpstime is not a double")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_PointSourceID = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["PointSourceID"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.integer(data[["PointSourceID"]]))
    errors = append(errors, "Invalid data: PointSourceID is not an integer")

  if (min(data[["PointSourceID"]]) < 0)
    errors = append(errors, "Invalid data: PointSourceID is not an unsigned integer")

  if (max(data[["PointSourceID"]]) > 2^16 - 1)
    errors = append(errors, "Invalid data: PointSourceID is not an unsigned integer on 16 bits")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_RGB = function(data, behavior = "bool")
{

  errors = character(0)

  if (is.null(data[["R"]]) & is.null(data[["G"]]) & is.null(data[["B"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.integer(data[["R"]]))
    errors = append(errors, "Invalid data: R is not an integer")

  if (!is.integer(data[["G"]]))
    errors = append(errors, "Invalid data: G is not an integer")

  if (!is.integer(data[["B"]]))
    errors = append(errors, "Invalid data: B is not an integer")

  if (min(data[["R"]]) < 0)
    errors = append(errors, "Invalid data: R is not an unsigned integer")

  if (min(data[["G"]]) < 0)
    errors = append(errors, "Invalid data: G is not an unsigned integer")

  if (min(data[["B"]]) < 0)
    errors = append(errors, "Invalid data: B is not an unsigned integer")

  if (max(data[["R"]]) > 2^16 - 1)
    errors = append(errors, "Invalid data: R is not an unsigned integer on 16 bits")

  if (max(data[["G"]]) > 2^16 - 1)
    errors = append(errors, "Invalid data: G is not an unsigned integer on 16 bits")

  if (max(data[["B"]]) > 2^16 - 1)
    errors = append(errors, "Invalid data: B is not an unsigned integer on 16 bits")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_valid_NIR = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["NIR"]]))
    return(error_handling_engine(errors, behavior))

  if (!is.integer(data[["NIR"]]))
    errors = append(errors, "Invalid data: NIR is not an integer")

  if (min(data[["PointSourceID"]]) < 0)
    errors = append(errors, "Invalid data: NIR is not an unsigned integer")

  if (max(data[["PointSourceID"]]) > 2^16 - 1)
    errors = append(errors, "Invalid data: NIR is not an unsigned integer on 16 bits")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_compliant_ReturnNumber = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["ReturnNumber"]]))
    return(error_handling_engine(errors, behavior))

  class0 = fast_countequal(data[["ReturnNumber"]], 0L)

  if (class0 > 0)
    errors = append(errors, paste0("Invalid data: ", class0, " points with a return number equal to 0 found."))

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_compliant_NumberOfReturns = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["NumberOfReturns"]]))
    return(error_handling_engine(errors, behavior))

  class0 = fast_countequal(data[["NumberOfReturns"]], 0L)

  if (class0 > 0)
    errors = append(errors, paste0("Invalid data: ", class0, " points with a number of returns equal to 0 found."))

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_compliant_ReturnNumber_vs_NumberOfReturns = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["ReturnNumber"]]) | is.null(data[["NumberOfReturns"]]))
    return(error_handling_engine(errors, behavior))

  s <- sum(data[["ReturnNumber"]] > data[["NumberOfReturns"]])

  if (s > 0)
    errors = append(errors, paste0("Invalid data: ", s, " points with a 'return number' greater than the 'number of returns'."))

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_compliant_RGB = function(data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["R"]]) & is.null(data[["G"]]) & is.null(data[["B"]]))
    return(error_handling_engine(errors, behavior))

  maxR <- maxG <- maxB <- 2^16 - 1
  if ("R" %in% names(data)) maxR = max(data[["R"]])
  if ("G" %in% names(data)) maxG = max(data[["G"]])
  if ("B" %in% names(data)) maxB = max(data[["B"]])

  if ((maxR > 0 & maxR <= 255) | (maxG > 0 & maxG <= 255) | (maxB > 0 & maxB <= 255))
    errors = append(errors, "Invalid data: RGB colors are recorded on 8 bits instead of 16 bits.")

  return(error_handling_engine(errors, behavior))
}

# ===== DATA vs. HEADER ====

#' @export
#' @rdname las_specification_tools
is_NIR_in_valid_format = function(header, data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["NIR"]]))
    return(error_handling_engine(errors, behavior))

  if (header[["Point Data Format ID"]] != 8)
    errors = append(errors, "Invalid file: the data contains a 'NIR' attribute but point data format is not set to 8")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_gpstime_in_valid_format = function(header, data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["gpstime"]]))
    return(error_handling_engine(errors, behavior))

  if (!header[["Point Data Format ID"]] %in% c(1,3,6,7,8))
    errors = append(errors, "Invalid file: the data contains a 'gpstime' attribute but point data format is not set to 1, 3, 6, 7 or 8.")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_RGB_in_valid_format = function(header, data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["R"]]) & is.null(data[["G"]]) & is.null(data[["B"]]))
    return(error_handling_engine(errors, behavior))

  if (!header[["Point Data Format ID"]] %in% c(2,3,8))
    errors = append(errors, "Invalid file: the data contains a 'RGB' field but point data format is not set to 2, 3 or 8")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_XY_larger_than_bbox = function(header, data, behavior = "bool")
{
  errors = character(0)

  if (max(data[["X"]]) > header[["Max X"]] | max(data[["Y"]]) > header[["Max Y"]] | min(data[["X"]]) < header[["Min X"]] | min(data[["Y"]]) < header[["Min Y"]])
    errors = append(errors, "Invalid file: some points are outside the bounding box defined by the header")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_XY_smaller_than_bbox = function(header, data, behavior = "bool")
{
  errors = character(0)

  if (max(data[["X"]]) < header[["Max X"]] | max(data[["Y"]]) < header[["Max Y"]] | min(data[["X"]]) > header[["Min X"]] | min(data[["Y"]]) > header[["Min Y"]])
    errors = append(errors, "Invalid file: the bounding box defined by the header does not correspond to the points.")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_Z_in_bbox = function(header, data, behavior = "bool")
{
  errors = character(0)

  if (max(data[["Z"]]) > header[["Max Z"]] | min(data[["Z"]]) < header[["Min Z"]])
    errors = append(errors, "Invalid file: some points are outside the elevation range defined by the header")

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_number_of_points_in_accordance_with_header = function(header, data, behavior = "bool")
{
  errors = character(0)

    if (nrow(data) != header[["Number of point records"]])
    errors = append(errors, paste0("Invalid file: header states the file contains ", header[["Number of point records"]], " points but ", nrow(data), " were found."))

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_number_of_points_by_return_in_accordance_with_header = function(header, data, behavior = "bool")
{
  errors = character(0)

  if (is.null(data[["ReturnNumber"]]))
    return(error_handling_engine(errors, behavior))

  n <- if (header[["Version Minor"]] < 4L) 5L else 15L
  header_number_of <- header[["Number of points by return"]]
  actual_number_of <- fast_table(data$ReturnNumber, n)

  for (i in 1:n)
  {
    if (actual_number_of[i] != header_number_of[i])
      errors = append(errors, paste0("Invalid file: the header states the file contains ", header_number_of[i], " returns numbered '", i, "' but ", actual_number_of[i], " were found."))
  }

  return(error_handling_engine(errors, behavior))
}

#' @export
#' @rdname las_specification_tools
is_extrabytes_in_accordance_with_data = function(header, data, behavior = "bool")
{
  errors = character(0)

  if (!is_defined_extrabytes(header))
    return(error_handling_engine(errors, behavior))

  extrabytes <- names(header$`Variable Length Records`$Extra_Bytes$`Extra Bytes Description`)

  if (!all(extrabytes %in% names(data)))
    errors = append(errors, "Invalid file: the header describes extra bytes attributes that are not in the data.")

  return(error_handling_engine(errors, behavior))
}