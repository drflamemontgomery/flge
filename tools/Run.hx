package tools;

import sys.io.File;
import haxe.Template;
import haxe.io.Path;
import sys.FileSystem;
import hxargs.Args;

class Run {
	public static function main() {
		// generate this path before calling Sys.setCwd()
		var templatePath = Path.join([Path.directory(Sys.programPath()), "templates"]);
		var args = Sys.args();
		var cwd = args.pop();
		Sys.setCwd(cwd);

		var getDoc:() -> String = null;
		var mainArgHandler = Args.generate([
			@doc("Creates a new FLGE project at the specified path")
			["new-project"] => function() {
				if (args.length == 0) {
					Sys.println("Error: Missing project path");
					var helpArgHandler = createHelpArgHandler();
					helpArgHandler.parse(["new-project"]);
					Sys.exit(1);
				}
				var projectPath = Path.normalize(FileSystem.absolutePath(args.shift()));
				var newProject = new NewProjectOptions(projectPath);
				var newProjectArgHandler = createNewProjectArgHandler(newProject);
				newProjectArgHandler.parse(args);
				createProject(newProject, Path.join([templatePath, "new-project"]));
			},
			@doc("Displays a list of available commands or the usage of a specific command")
			["help"] => function() {
				if (args.length > 0) {
					var helpArgHandler = createHelpArgHandler();
					helpArgHandler.parse(args);
				} else {
					Sys.println("Usage: haxelib run flge <command> [options]");
					Sys.println("Commands:");
					Sys.println(getDoc());
				}
			},
			_ => function(command:String) {
				Sys.println('Unknown command: ${command}');
				Sys.exit(1);
			}
		]);
		getDoc = mainArgHandler.getDoc;

		if (args.length == 0) {
			mainArgHandler.parse(["help"]);
			return;
		}
		mainArgHandler.parse(args.splice(0, 1));
	}

	private static function createHelpArgHandler() {
		return Args.generate([
			["new-project"] => function() {
				Sys.println("Usage: haxelib run flge new-project <path> [options]");
				Sys.println("Options:");
				Sys.println(createNewProjectArgHandler().getDoc());
			},
			["help"] => function() {
				Sys.println("Usage: haxelib run flge help <command>");
			},
			_ => function(command:String) {
				Sys.println('Unknown command: ${command}');
				Sys.exit(1);
			}
		]);
	}

	private static function validateNewProjectExists(newProject:NewProjectOptions):Void {
		if (newProject != null) {
			return;
		}
		Sys.println("Internal Error: NewProjectOptions missing");
		Sys.exit(1);
	}

	private static function createNewProjectArgHandler(?newProject:NewProjectOptions) {
		return Args.generate([
			@doc("Show additional detailed output")
			["--verbose"] => function() {
				validateNewProjectExists(newProject);
				newProject.verbose = true;
			},
			_ => function(option:String) {
				Sys.println('Unknown option: ${option}');
				Sys.exit(1);
			}
		]);
	}

	private static function createProject(newProject:NewProjectOptions, templatePath:String):Void {
		var projectPath = newProject.path;
		var folderName = Path.withoutDirectory(projectPath);
		folderName = StringTools.trim(folderName);
		var projectName = "";
		var needsUpper = false;
		for (i in 0...folderName.length) {
			var char = folderName.charAt(i);
			if (i == 0) {
				if (~/[a-zA-Z]/.match(char)) {
					// first character of a type name must be upper case
					needsUpper = true;
				} else if (char != "_") {
					// skip invalid character
					continue;
				}
			} else {
				if (~/[\s\-]/.match(char)) {
					// make the *next* character upper case
					// in other words, we basically convert to CamelCase when we
					// encounter whitespace or dashes
					needsUpper = true;
					continue;
				}
				if (!~/[0-9a-zA-Z_]/.match(char)) {
					// skip invalid character
					continue;
				}
			}
			if (needsUpper) {
				needsUpper = false;
				projectName += char.toUpperCase();
			} else {
				projectName += char;
			}
		}
		if (newProject.verbose) {
			Sys.println('New project: ${projectName}');
		}
		if (FileSystem.exists(projectPath)) {
			if (!FileSystem.isDirectory(projectPath)) {
				Sys.println('Failed to create project. File with project name already exists: ${projectPath}');
				Sys.exit(1);
			} else if (FileSystem.readDirectory(projectPath).length > 0) {
				Sys.println('Failed to create project. New project folder is not empty: ${projectPath}');
				Sys.exit(1);
			}
		}
		createFolder(projectPath, newProject.verbose);
		var srcPath = Path.join([projectPath, "src"]);
		createFolder(srcPath, newProject.verbose);

		//var readmeTemplatePath = Path.join([templatePath, "README.md"]);
		//var readmePath = Path.join([projectPath, "README.md"]);
		//copyFile(readmeTemplatePath, readmePath, newProject.verbose);

		var projectXmlTemplatePath = Path.join([templatePath, "project.xml"]);
		var projectXmlPath = Path.join([projectPath, "project.xml"]);
		var projectTitle = projectName;
		var projectPackage = "com.example." + projectName;
		var projectCompany = "My Company";
		var projectXmlTemplateParams = {
			projectName: projectName,
			projectTitle: projectTitle,
			projectPackage: projectPackage,
			projectCompany: projectCompany,
		};
		createFileFromTemplate(projectXmlTemplatePath, projectXmlPath, projectXmlTemplateParams, newProject.verbose);

		var mainTemplatePath = Path.join([templatePath, "Main.hx"]);
		var mainPath = Path.join([srcPath, "Main.hx"]);
    copyFile(mainTemplatePath, mainPath, newProject.verbose);

		var assetsTemplatePath = Path.join([templatePath, "assets"]);
		var assetsPath = Path.join([projectPath, "assets"]);
		copyFolder(assetsTemplatePath, assetsPath, newProject.verbose);
	}

	private static function createFileFromTemplate(fromPath:String, toPath:String, templateParams:Dynamic, verbose:Bool):Void {
		var templateContent:String = null;
		try {
			templateContent = File.getContent(fromPath);
		} catch (e:Dynamic) {
			Sys.println('Failed to read template file: ${fromPath}');
			Sys.exit(1);
		}
		var template = new Template(templateContent);
		var templateResult = template.execute(templateParams);
		try {
			if (verbose) {
				Sys.println('Create file: ${toPath}');
			}
			File.saveContent(toPath, templateResult);
		} catch (e:Dynamic) {
			Sys.println('Failed to create file: ${toPath}');
			Sys.exit(1);
		}
	}

	private static function createFolder(folderPath:String, verbose:Bool):Void {
		try {
			if (verbose) {
				Sys.println('Create folder: ${folderPath}');
			}
			FileSystem.createDirectory(folderPath);
		} catch (e:Dynamic) {
			Sys.println('Failed to create folder: ${folderPath}');
			Sys.exit(1);
		}
	}

	private static function copyFile(fromPath:String, toPath:String, verbose:Bool):Void {
		try {
			if (verbose) {
				Sys.println('Create file: ${toPath}');
			}
			File.copy(fromPath, toPath);
		} catch (e:Dynamic) {
			Sys.println('Failed to create file: ${toPath}');
			Sys.exit(1);
		}
	}

	private static function copyFolder(fromPath:String, toPath:String, verbose:Bool):Void {
		createFolder(toPath, verbose);
		for (fileName in FileSystem.readDirectory(fromPath)) {
			var fileFrom = Path.join([fromPath, fileName]);
			var fileTo = Path.join([toPath, fileName]);
			if (FileSystem.isDirectory(fileFrom)) {
				copyFolder(fileFrom, fileTo, verbose);
			} else {
				copyFile(fileFrom, fileTo, verbose);
			}
		}
	}
}

class NewProjectOptions {
	public function new(path:String) {
		this.path = Path.removeTrailingSlashes(Path.normalize(path));
	}

	public var path:String;
	public var verbose:Bool;
}
