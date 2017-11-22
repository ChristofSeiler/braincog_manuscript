/**
 * Christof Seiler
 * Department of Statistics, Stanford University
 */

#include <itkImageFileWriter.h>
#include <itkImageFileReader.h>
#include <itkN4BiasFieldCorrectionImageFilter.h>

const unsigned int Dimension = 3;

typedef float PixelType;
typedef itk::Image< PixelType, Dimension > ImageType;
typedef itk::ImageFileReader< ImageType > ImageReaderType;
typedef itk::ImageFileWriter< ImageType > ImageWriterType;

typedef int MaskPixelType;
typedef itk::Image< MaskPixelType, Dimension > MaskImageType;
typedef itk::ImageFileReader< MaskImageType > MaskImageReaderType;

typedef itk::N4BiasFieldCorrectionImageFilter< ImageType,MaskImageType > BiasCorrectionType;


int main( int argc, char** argv ) {
	
	if(argc < 3) {
		std::cout << "Usage: N4BiasFieldCorrection InputFileName OutputFileName MaskFileName" << std::endl;
		return EXIT_FAILURE;
	}
    
    std::string inputFileName = argv[1];
    std::string outputFileName = argv[2];
    
    ImageReaderType::Pointer imageReader = ImageReaderType::New();
    imageReader->SetFileName(inputFileName);
    imageReader->Update();
    
    BiasCorrectionType::Pointer biasCorrection = BiasCorrectionType::New();
    biasCorrection->SetInput(imageReader->GetOutput());
    if(argc == 4) {
        std::string maskFileName = argv[3];
        std::cout << "mask provided: " << maskFileName << std::endl;
        
        MaskImageReaderType::Pointer maskReader = MaskImageReaderType::New();
        maskReader->SetFileName(maskFileName);
        maskReader->Update();
        
        biasCorrection->SetMaskImage(maskReader->GetOutput());
        biasCorrection->SetMaskLabel(1);
    }
    biasCorrection->Update();

    ImageWriterType::Pointer imageWriter = ImageWriterType::New();
    imageWriter->SetInput(biasCorrection->GetOutput());
    imageWriter->SetFileName(outputFileName);
    imageWriter->Update();
    
    return EXIT_SUCCESS;
}
