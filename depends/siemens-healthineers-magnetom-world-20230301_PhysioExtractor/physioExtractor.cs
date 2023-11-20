// -----------------------------------------------------------------------------
//	  Copyright (C) Siemens Healthcare GmbH 2022  All Rights Reserved.
// -----------------------------------------------------------------------------
// 
//      Project: Advanced physio logging
//      Lang: C#
//
// -----------------------------------------------------------------------------
// please note: This demonstration program comes without any warranty and only serves the purpose
//              of illustrating the concept for extracting physio data embedded in a dedicated DICOM File

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Xsl;
using System.IO.Compression;
using System.Runtime.InteropServices;
using System.Windows.Forms;


namespace physioExtractorRunner
{
    class ProgramArguments
    {
        public string outputDir = "output";
        public string inputFile = "";
        public List<string> listOfStyles = new List<string>();
        public bool bSaveXML = false;
        public bool bVerbose = false;
    }

    class Program
    {
        static void Main(string[] args)
        {
            ProgramArguments parsedArgs = new ProgramArguments();
            if (!parseArguments(args, ref parsedArgs))
                return;

            if (!File.Exists(parsedArgs.inputFile))
            {
                Console.WriteLine(@"Could not find DICOM file {0}", parsedArgs.inputFile);
                return;
            }

            try
            {
                if (!Directory.Exists(parsedArgs.outputDir))
                {
                    Directory.CreateDirectory(parsedArgs.outputDir);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(@"Could not use/create output directory {0}: {1}",parsedArgs.outputDir, e);
                throw;
            }

            //get XML stream - either as input or from non-image DICOM file
            Stream decompressedXMLstream = new MemoryStream();
            if (".xml" == Path.GetExtension(parsedArgs.inputFile)) //check whether we can read in directly an existing XML
            {
                FileStream xmlFileStream = File.OpenRead(parsedArgs.inputFile);
                xmlFileStream.CopyTo(decompressedXMLstream);
            }
            else
            {
                // the usual case: get XML stream from a DICOM file
                if (!obtainXMLstreamFromDicom(parsedArgs.inputFile, ref decompressedXMLstream, parsedArgs))
                {
                    Console.WriteLine("Could not obtain XML stream from input file");
                    return;
                }

                if (parsedArgs.bSaveXML)
                {
                    string strOutputXMLFileName = Path.Combine(parsedArgs.outputDir, Path.GetFileNameWithoutExtension(parsedArgs.inputFile) + ".xml");
                    saveXML(decompressedXMLstream, strOutputXMLFileName);
                }
            }

            if (0 == parsedArgs.listOfStyles.Count)
            {
                Console.WriteLine("no styles specified - skipping xml to txt step");
            }
            else
            {
                if(parsedArgs.bVerbose)
                    Console.WriteLine("applying specified xsl translations!");
                applyXslts(decompressedXMLstream, parsedArgs);                
            }
        }

        static bool parseArguments(string[] args, ref ProgramArguments parsedArgs)
        {
            if (args.Length < 1)
            {
                showHelp();
                return false;
            }

            for (int i = 0; i < args.Length; i++)
            {
                //Console.WriteLine(@"args[{0}]: {1}", i, args[i]);
                switch (args[i])
                {
                    case "-h":
                        showHelp();
                        return false;
                        //break;
                    case "-x":
                        parsedArgs.bSaveXML = true;
                        break;
                    case "-i":
                        if (args.Length < i + 2)
                            return false;
                        i++; //option with parameter
                        parsedArgs.inputFile = args[i];
                        break;
                    case "-v":
                        parsedArgs.bVerbose = true;
                        break;
                    case "-o":
                        if (i + 1 < args.Length && args[i + 1][0] != '-') //make sure entry is there
                        {
                            parsedArgs.outputDir = args[i + 1]; //let's skip validity check - up to the user to provide meaningful entry
                        }
                        break;
                    case "-s":
                        while (i+1 < args.Length && args[i+1][0]!='-') //while not at the end of the arguments and no new option (identified by '-')...
                        {
                            i++;
                            string strFileName = Path.GetFileName(args[i]);
                            string strPath = args[i].Substring(0, args[i].Length - strFileName.Length);
                            if (0 == strPath.Length)
                                strPath = "."; //make sure the path is not empty
                            
                            string[] listOfXSLfiles = Directory.GetFiles(strPath, strFileName);
                            parsedArgs.listOfStyles.AddRange(listOfXSLfiles);
                        }

                        break;
                    default:
                        break;
                }
            }

            return true;
        }

        // save the XML stream to file
        static void saveXML(Stream decompressedXMLstream, string strOutputXMLFileName)
        {
            if (File.Exists(strOutputXMLFileName))
                File.Delete(strOutputXMLFileName);
            decompressedXMLstream.Position = 0;

            StreamWriter xmlFileStream = File.CreateText(strOutputXMLFileName);
            StreamReader reader = new StreamReader(decompressedXMLstream);
            xmlFileStream.Write(reader.ReadToEnd().Replace("\n", Environment.NewLine));

            xmlFileStream.Close();
            Console.WriteLine("XML stream written to {0}", strOutputXMLFileName);
        }

        // apply xsl transform to physio xml data
        static void applyXslts( Stream XMLstream, ProgramArguments parsedArgs)
        {
            string baseFileName = Path.GetFileNameWithoutExtension(parsedArgs.inputFile) + ".txt";
            foreach (var xsltFilename in parsedArgs.listOfStyles)
            {
                if (!File.Exists(xsltFilename))
                {
                    Console.WriteLine(@"{0} does not exist - skipping, trying next one!", xsltFilename);
                    continue;
                }
                //Create a new XslCompiledTransform and load the compiled transformation.
                XslCompiledTransform xslt = new XslCompiledTransform();
                XsltSettings xsltSettings = new XsltSettings(false, true);
                xslt.Load(xsltFilename, xsltSettings, new XmlUrlResolver());

                XmlReaderSettings xmlReaderSettings = new XmlReaderSettings();
                xmlReaderSettings.DtdProcessing = DtdProcessing.Parse;
                XsltArgumentList xsltArguments = new XsltArgumentList();
                // Execute the transformation and output the results to a file.
                string outputFilename = Path.Combine(parsedArgs.outputDir, Path.GetFileNameWithoutExtension(xsltFilename) + "_" + baseFileName);
                StreamWriter writer = File.CreateText(outputFilename);
                XMLstream.Position = 0; //make sure we read from the beginning
                if (parsedArgs.bVerbose) {
                    Console.WriteLine(@"applying {0}", xsltFilename);
                }

                xslt.Transform(XmlReader.Create(XMLstream, xmlReaderSettings), xsltArguments, writer);
            }
        }

        // get XML stream from a DICOM file
        static bool obtainXMLstreamFromDicom( string strDicomFileName, ref Stream decompressedXMLstream, ProgramArguments parsedArgs )
        {
            Stream compressedXMLstream = new MemoryStream();
            // first get the compressed strem...
            if (!obtainCompressedXMLstream(strDicomFileName, ref compressedXMLstream, parsedArgs))
            {
                Console.WriteLine("Could not extract XML stream from DICOM file!");
                return false;
            }

            //... then decompress
            if (!decompressXMLstream(compressedXMLstream, ref decompressedXMLstream))
            {
                Console.WriteLine("Could not decompress XML stream extracted from DICOM file!");
                return false;
            }
            
            return true;
        }

        // get the compressed XML stream from a DICOM
        static bool obtainCompressedXMLstream( string dicomFileName, ref Stream compressedXMLstream, ProgramArguments parsedArgs)
        {
            FileStream dicomFile = File.OpenRead(dicomFileName);
            Dictionary<string, Tuple<long, long>> dDicomTagDictionary = new Dictionary<string, Tuple<long, long>>();
            
            // get a full list of DICOM tags
            if (!extractDicomTagsToStartaddressDictionary(dicomFile, ref dDicomTagDictionary, parsedArgs))
            {
                return false;
            }

            // check for image or spectroscopy tag
            string strDICOMtag = "";
            bool bFoundRelevantDICOMTag = false;
            if (dDicomTagDictionary.ContainsKey("0x7FE00010"))
            {
                strDICOMtag = "0x7FE00010";
                bFoundRelevantDICOMTag = true;
            }
            if (dDicomTagDictionary.ContainsKey("0x7FE11010"))
            {
                strDICOMtag = "0x7FE11010";
                bFoundRelevantDICOMTag = true;
            }
            if(bFoundRelevantDICOMTag)
            {
                Tuple<long, long> posAndLengthOfDicomEntry = dDicomTagDictionary[strDICOMtag];
                dicomFile.Position = posAndLengthOfDicomEntry.Item1;
                int nLength = (int)posAndLengthOfDicomEntry.Item2;

                dicomFile.CopyTo(compressedXMLstream, nLength);
                if(parsedArgs.bVerbose)
                    Console.WriteLine("found {0}", strDICOMtag);
                return true;
            }

            return true;
        }

        // decompress the XML stream
        static bool decompressXMLstream( Stream compressedXMLstream, ref Stream decompressedXMLstream)
        {
            compressedXMLstream.Position = 0;
            System.IO.Compression.GZipStream decompressedStream = new System.IO.Compression.GZipStream(compressedXMLstream,
                System.IO.Compression.CompressionMode.Decompress);

            //remove trailing binary byte; note that strictly speaking this should be done in the compressed stream - but I am not sure whether trailing 0s are allowed there or not...
            decompressedStream.CopyTo(decompressedXMLstream);
            if (decompressedXMLstream.Length > 0)
            {
                byte[] lastByte = new byte[1];
                decompressedXMLstream.Position = decompressedXMLstream.Length - 1;
                decompressedXMLstream.Read(lastByte, 0, 1);
                if (lastByte[0] == 0)
                    decompressedXMLstream.SetLength(decompressedXMLstream.Length - 1); // remove trailing zeros; required starting with NX dicom engine due to forced even data size........

                return true; //seems we got something with a given length
            }
            else
            {
                return false; //if length is not >0 something must have gone wrong
            }

        }


        // a quick and dirty DICOM engine for fast parsing
        static bool extractDicomTagsToStartaddressDictionary( Stream dicomStream, ref Dictionary<string, Tuple<long, long>> dDicomTagDictionary, ProgramArguments parsedArgs )
        {
            //go to start of DICOM ident
            long lStreamLength = dicomStream.Length;
            const int lDicomPreambleLength = 128;
            const int lDicomPrefixLength = 4;
            const int lGroupLength = 2;
            const int lElementLength = 2;
            const int lVRLength = 2;
            uint nGroup;
            uint nElement;
            string VRstring;
            long nLength;
            byte[] buffer = new byte[128];
            List<long> vGroupEndPos = new List<long>();
            if (lStreamLength < (lDicomPreambleLength + lDicomPrefixLength)) //check that we have at least preamble and prefix
            {
                Console.WriteLine("File too small!");
                return false;
            }

            dicomStream.Position = lDicomPreambleLength;
            if (0 == dicomStream.Read(buffer, 0, lDicomPrefixLength))
            {
                Console.WriteLine("Could not read from data stream - aborting!");
                return false;
            }

            //check whether this is a DICOM stream
            if(Encoding.ASCII.GetString(buffer).Substring(0,4) != "DICM")
            {
                Console.WriteLine("No DICOM prefix found - aborting!");
                return false;
            }
            if (parsedArgs.bVerbose)
                Console.WriteLine("DICOM prefix found! :-)");

            // now that we know it's a DICOM, let's try to parse the tags
            int nestingLevel = 0;
            long nGroupEndPos = dicomStream.Length;
            while (lGroupLength == dicomStream.Read(buffer, 0, lGroupLength))
            {
                nGroup = (uint)(buffer[1] << 8 | buffer[0]);

                if (lElementLength != dicomStream.Read(buffer, 0, lElementLength))
                    return false;

                nElement = (uint)(buffer[1] << 8 | buffer[0]);

                string strDicomTag = String.Format(@"0x{0:X4}{1:X4}", nGroup, nElement);

                int nValueLength = 2;
                //special group items, have no VR entry
                if ( (strDicomTag == "0xFFFEE000") || (strDicomTag == "0xFFFEE00D") || (strDicomTag == "0xFFFEE0DD") )
                {
                    nValueLength = 4;
                    VRstring = "na";
                }
                else
                {
                    if (lVRLength != dicomStream.Read(buffer, 0, lVRLength))
                        return false;

                    VRstring = Encoding.ASCII.GetString(buffer).Substring(0, 2);
                    if ((VRstring == "OB") ||
                        (VRstring == "OW") ||
                        (VRstring == "OF") ||
                        (VRstring == "SQ") ||
                        (VRstring == "UT") ||
                        (VRstring == "UN")
                    )
                    {
                        uint nNumReservedBytes = 2;
                        dicomStream.Position += nNumReservedBytes;
                        nValueLength = 4;
                    }
                }

                if (nValueLength != dicomStream.Read(buffer, 0, nValueLength))
                    return false;
                if(nValueLength ==2)
                    nLength = (short)(buffer[1] << 8 | buffer[0]);
                else
                    nLength = (buffer[3] << 24 | buffer[2] << 16 | buffer[1] << 8 | buffer[0]);

                //handling of nested groups
                if ((nestingLevel > 0) && (strDicomTag == "0xFFFEE0DD"))
                {
                    nestingLevel--;
                }
                if ((nestingLevel > 0) && (dicomStream.Position >= nGroupEndPos))
                {
                    nestingLevel--;
                    vGroupEndPos.RemoveAt(vGroupEndPos.Count-1); //remove last element
                    if (vGroupEndPos.Count > 0)
                    {
                        nGroupEndPos = vGroupEndPos[vGroupEndPos.Count - 1];
                    }
                    else
                    { 
                        nGroupEndPos = dicomStream.Length; //set group end to end of stream for now
                    }
                }

                if (parsedArgs.bVerbose)
                {
                    Console.WriteLine("".PadLeft(nestingLevel) + @"Found DICOM tag ({0:X4})({1:X4}) with VR={2} and length={3}", nGroup,
                        nElement, VRstring, nLength);
                }

                //this group length is covered by its elements
                if (strDicomTag == "0xFFFEE000")
                {
                    nLength = 0;
                }

                if (VRstring == "SQ") //one level of nesting starts
                {
                    if (0 != nLength)
                    {
                        nestingLevel++;
                        if (nLength > 0) //this has group has a length - end group afterwards
                        {
                            nGroupEndPos = dicomStream.Position + nLength;
                            vGroupEndPos.Add(nGroupEndPos); //keep track of the group endings
                            nLength = 0;
                        }
                    }
                }

                if (-1 == nLength) //handle fields with unspecified length (usually nested fields!?!)
                    nLength = 0;

                if (0 != nLength)
                {
                    string strNestedDicomTag = strDicomTag;
                    if (nestingLevel > 0)
                        strNestedDicomTag = strDicomTag + "_" + nestingLevel.ToString();

                    if (!dDicomTagDictionary.ContainsKey(strNestedDicomTag))
                    {
                        if (nLength < 0) //this happened when the group info length was not reset
                        {
                            Console.WriteLine("nMaxLength negative for {0}", strNestedDicomTag);
                            return false;
                        }
                        
                        dDicomTagDictionary.Add(strNestedDicomTag, new Tuple<long, long>(dicomStream.Position, nLength));
                    }

                    dicomStream.Position += nLength;
                }
            }
            return true;

        }

        static void showHelp()
        {
            Console.WriteLine("At least 1 parameter required (although not meaningful):\nprogram [-h] [-x] [-v] [-o outputDir] [-s Style_PULS.xsl] -i input.dcm (or input.xml)");
            Console.WriteLine("parameters:");
            Console.WriteLine("-h   show this help");
            Console.WriteLine("-x   optional: enable saving of XML to output directory. Default: Off");
            Console.WriteLine(
                "-v   optional: enable verbose mode (more output regarding DICOM parsing and application of xsl transformations). Default: Off");
            Console.WriteLine("-o   optional: specify output directory. Default: <CurrentDir>\\output");
            Console.WriteLine("-s   optional: list of xsl transformation files to by applied to the XML file; can contain wildcards. This can be omitted e.g. if only the XML export is of interest (-x).");
            Console.WriteLine("-i   mandatory input file, either a DICOM file containing the compressed XML file or directly the previously extracted XML");
        }
    }
}
