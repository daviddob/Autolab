module AssessmentImport

  def cleanTemp
    begin
      FileUtils.remove_dir(Rails.root.join("courses", @course.name, "importTemp"))
    rescue Errno::ENOENT => e
      return
    end
  end

  def writeRBFiles(asmt_name)
    course_root = Rails.root.join("courses", @course.name, "importTemp")
    File.open(File.join(course_root, asmt_name, asmt_name + ".rb"), "wb") do |f|
      f.write "require \"AssessmentBase.rb\"

module #{asmt_name.capitalize}
  include AssessmentBase

  def assessmentInitialize(course)
    super(\"#{asmt_name}\",course)
    @problems = []
  end

end"
      end
  end

  def importAsmtFromTar
    cleanTemp
    tarFile = params["tarFile"]
    if tarFile.nil?
      flash[:error] = "Please select an assessment tarball for uploading."
      return
    end

    begin
      tarFile = File.new(tarFile.open, "rb")
      tar_extract = Gem::Package::TarReader.new(tarFile)
      tar_extract.rewind
    rescue StandardError => e
      flash[:error] = "Error while reading the tarball -- #{e.message}."
      return
    end

    # If all requirements are satisfied, extract assessment files.
    begin
      FileUtils.mkdir_p(Rails.root.join("courses", @course.name, "importTemp"))
      course_root = Rails.root.join("courses", @course.name, "importTemp")
      tar_extract.rewind
      tar_extract.each do |entry|
        relative_pathname = entry.full_name
        if entry.directory?
          FileUtils.mkdir_p(File.join(course_root, relative_pathname),
            mode: entry.header.mode, verbose: false)
          if !entry.full_name.chomp("/").include? "/"
            writeRBFiles(entry.full_name.chomp("/"))
          end
        elsif entry.file?
          FileUtils.mkdir_p(File.join(course_root, File.dirname(relative_pathname)),
            mode: entry.header.mode, verbose: false)
          File.open(File.join(course_root, relative_pathname), "wb") do |f|
            f.write entry.read
          end
          FileUtils.chmod entry.header.mode, File.join(course_root, relative_pathname),
          verbose: false
        elsif entry.header.typeflag == "2"
          File.symlink entry.header.linkname, File.join(course_root, relative_pathname)
        end
      end
      tar_extract.close

    rescue StandardError => e
      flash[:error] = "Error while extracting tarball to server -- #{e.message}."
      cleanTemp && return
    end

    Dir[Rails.root.join(course_root, "*")].select { |e| File.directory?(e) }.each do |directory|
      props = YAML.load(File.open(Rails.root.join(directory, "properties.yml"), "r") { |f| f.read })
      
      assessmentYAMLOk(props, directory)

      return if !flash[:error].nil?

      moveFiles(props, directory)

      params["assessment_name"] = props["general"]["name"]
      
      importAssessment
    end

    cleanTemp && return
  end


  def assessmentYAMLOk(props, directory)
    unless !props["general"]["name"].nil?
      flash[:error] = "the assessment in the folder #{directory.split("/")[-1]} has a YAML file which is missing the name property"
      redirect_to(action: "multiImport") && return
    end 

    if not @course.assessments.find_by(name: props["general"]["name"]).nil?
      flash[:error] = "An assessment with the same name #{props["general"]["name"]} already exists for the course. Please use a different name."
      redirect_to(action: "multiImport") and return
    end

    if props.has_key?("autograder")
      
      if props["autograder"].has_key?("makefile") && props["autograder"]["makefile"] != ""
        make = Dir[Rails.root.join(directory, props["autograder"]["makefile"])].select { |e| File.file?(e) }
        
        if make.length != 1
          flash[:error] = "the assessment in the folder #{directory.split("/")[-1]} has a YAML file which has the autograder property but no makefile provided"
          redirect_to(action: "multiImport") && return
        end
      
      else
        flash[:error] = "the assessment in the folder #{directory.split("/")[-1]} has a YAML file which has the autograder property but no makefile defined"
        redirect_to(action: "multiImport") && return
      end

      if props["autograder"].has_key?("tarfile") && props["autograder"]["tarfile"] != ""
        tar = Dir[Rails.root.join(directory, props["autograder"]["tarfile"])].select { |e| File.file?(e) }
      
        if tar.length != 1
          flash[:error] = "the assessment in the folder #{directory.split("/")[-1]} has a YAML file which has the autograder property but no tarfile provided"
          redirect_to(action: "multiImport") && return
        end
      
      else
        flash[:error] = "the assessment in the folder #{directory.split("/")[-1]} has a YAML file which has the autograder property but no tarfile defined"
        redirect_to(action: "multiImport") && return
      end
    end
    return true
  end

  def moveFiles(props, directory)
      newAssessmentPath = Rails.root.join("courses", @course.name, directory.split("/")[-1]).to_s

      begin
        FileUtils.remove_dir(newAssessmentPath)
      rescue Errno::ENOENT => e

      end

      FileUtils.mv(directory,newAssessmentPath)
      FileUtils.mv(Rails.root.join(newAssessmentPath, "properties.yml"), Rails.root.join(newAssessmentPath, props["general"]["name"] + ".yml"))
      FileUtils.mv(Rails.root.join(newAssessmentPath, props["autograder"]["tarfile"]), Rails.root.join(newAssessmentPath, "autograde.tar")) unless props["autograder"]["tarfile"] == "autograde.tar"
      FileUtils.mv(Rails.root.join(newAssessmentPath, props["autograder"]["makefile"]), Rails.root.join(newAssessmentPath, "autograde-Makefile")) unless props["autograder"]["makefile"] == "autograde-Makefile"
  end
end

