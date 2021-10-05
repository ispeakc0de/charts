package main

import (
	"bytes"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"text/template"

	"gopkg.in/yaml.v2"

	//	"github.com/davecgh/go-spew/spew"
	"github.com/Masterminds/sprig/v3"
	"github.com/gobuffalo/packr"
)

type HubExperimentsMap map[string]ExperimentTemplate

type HubTemplate struct {
	Name        string                        `yaml:"name"`
	Descritpion string                        `yaml:"description"`
	Platform    string                        `yaml:"platform"`
	Experiments map[string]ExperimentTemplate `yaml:"experiments"`
}

type ExperimentTemplate struct {
	Name     string `yaml:"name"`
	Template string `yaml:"template"`
	Engine   string `yaml:"engine"`
}

func GetTemplate(context WorkflowSettings, experimentName string) string {
	return context.Experiments[experimentName].Template
}

func GetEngine(context WorkflowSettings, experimentName string) string {
	return context.Experiments[experimentName].Engine
}

type ExperimentSettings struct {
	Name      string      `yaml:"name"`
	Label     string      `yaml:"label"`
	Composant string      `yaml:"composant"`
	Platform  string      `yaml:"platform"`
	Namespace string      `yaml:"namespace"`
	Kind      string      `yaml:"kind"`
	Args      interface{} `yaml:"args"`
}

type WorkflowSettings struct {
	Name        string            `yaml:"name"`
	Experiments HubExperimentsMap `yaml:"experiments"`
	Workflow    Workflow          `yaml:"workflow"`
}

type Workflow struct {
	Name        string   `yaml:"name"`
	Experiments []string `yaml:"experiments"`
}

type Experiment struct {
	Name      string      `yaml:"name"`
	Template  string      `yaml:"template"`
	Label     string      `yaml:"label"`
	Composant string      `yaml:"composant"`
	Kind      string      `yaml:"kind"`
	Args      interface{} `yaml:"args"`
}

type Manifests []struct {
	Name        string       `yaml:"name"`
	Description string       `yaml:"description"`
	Namespace   string       `yaml:"namespace"`
	Platform    string       `yaml:"platform"`
	GitURL      string       `yaml:"gitUrl"`
	Workflows   []Workflow   `yaml:"workflows"`
	Experiments []Experiment `yaml:"experiments"`
}

var (
	hubs Manifests
)

func (m *Manifests) load(manifestPath string) *Manifests {

	yamlFile, err := ioutil.ReadFile(manifestPath)
	if err != nil {
		log.Printf("yamlFile.Get err   #%v ", err)
	}
	err = yaml.Unmarshal(yamlFile, m)
	if err != nil {
		log.Fatalf("Unmarshal: %v", err)
	}

	return m
}

func process(t *template.Template, vars interface{}) string {
	var tmplBytes bytes.Buffer

	err := t.Execute(&tmplBytes, vars)
	if err != nil {
		panic(err)
	}
	return tmplBytes.String()
}

func ProcessTpl(fileName string, vars interface{}) string {
	// tmpl, err := template.ParseFiles(fileName)
	tmpl, err := template.New("").Funcs(template.FuncMap{"GetTemplate": GetTemplate, "GetEngine": GetEngine}).Funcs(sprig.TxtFuncMap()).Parse(fileName)
	//        tmpl, err := template.New("").Funcs(sprig.FuncMap()).Parse(fileName)

	if err != nil {
		panic(err)
	}
	return process(tmpl, vars)
}

func writeToFile(filename string, data string) {
	destination, err := os.Create(filename)
	if err != nil {
		fmt.Println("os.Create:", err)
		return
	}
	defer destination.Close()
	fmt.Fprintf(destination, "%s", data)
}

func main() {
	currentPath, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}
	buildPathDefault := currentPath + "/build"

	manifestPath := flag.String("manifest", "", "(Required) YAML Manifest that describe de hub")
	buildPath := flag.String("output", buildPathDefault, "(Optionnal) The directory where hubs should be generated")
	flag.Parse()
	if *manifestPath == "" {
		fmt.Print("Aucun manifest n'a été fourni")
		flag.PrintDefaults()
		os.Exit(1)
	}
	fmt.Print("Generating hub from: ", *manifestPath, "\n")
	fmt.Print("Generating hub into: ", *buildPath, "\n")

	os.MkdirAll(*buildPath, os.ModePerm)

	hubs.load(*manifestPath)
	box := packr.NewBox("./templates")

	for hub := range hubs {
		fmt.Print("Generating hub: ", hubs[hub].Name, "\n")
		os.MkdirAll(*buildPath+"/charts/"+hubs[hub].Name, os.ModePerm)
		os.MkdirAll(*buildPath+"/charts/"+hubs[hub].Name+"/icons", os.ModePerm)
		var hubSettings HubTemplate
		hubSettings.Name = hubs[hub].Name
		tmp := make(HubExperimentsMap)

		for experiment := range hubs[hub].Experiments {
			// Configuration des experiments
			var settings ExperimentSettings
			settings.Name = hubs[hub].Name + "-" + hubs[hub].Experiments[experiment].Name
			settings.Args = hubs[hub].Experiments[experiment].Args
			settings.Platform = hubs[hub].Platform
			settings.Namespace = hubs[hub].Namespace
			settings.Label = hubs[hub].Experiments[experiment].Label
			settings.Kind = hubs[hub].Experiments[experiment].Kind

			// Generation des templates
			ChaosExperimentTemplate, err := box.FindString(hubs[hub].Experiments[experiment].Template + "/" + hubs[hub].Experiments[experiment].Template + ".tpl")
			if err != nil {
				log.Fatal(err)
			}
			ChaosExperimentIcon, err := box.FindString(hubs[hub].Experiments[experiment].Template + "/" + hubs[hub].Experiments[experiment].Template + ".png")
			if err != nil {
				log.Fatal(err)
			}
			ChaosChartServiceTemplate, err := box.FindString(hubs[hub].Experiments[experiment].Template + "/" + hubs[hub].Experiments[experiment].Template + ".chartserviceversion.tpl")
			if err != nil {
				log.Fatal(err)
			}
			ChaosEngineTemplate, err := box.FindString("engine.tpl")
			if err != nil {
				log.Fatal(err)
			}
			ChaosExperiment := ProcessTpl(ChaosExperimentTemplate, settings)
			ChaosChartServiceVersion := ProcessTpl(ChaosChartServiceTemplate, settings)
			ChaosEngine := ProcessTpl(ChaosEngineTemplate, settings)

			// Ecriture des templates sur le disque
			os.MkdirAll(*buildPath+"/charts/"+hubs[hub].Name+"/"+settings.Name, os.ModePerm)
			writeToFile(*buildPath+"/charts/"+hubs[hub].Name+"/"+settings.Name+"/experiment.yaml", ChaosExperiment)
			writeToFile(*buildPath+"/charts/"+hubs[hub].Name+"/icons/"+settings.Name+".png", ChaosExperimentIcon)
			writeToFile(*buildPath+"/charts/"+hubs[hub].Name+"/"+settings.Name+"/engine.yaml", ChaosEngine)
			writeToFile(*buildPath+"/charts/"+hubs[hub].Name+"/"+settings.Name+"/"+settings.Name+".chartserviceversion.yaml", ChaosChartServiceVersion)

			var ExperimentTemplate ExperimentTemplate
			ExperimentTemplate.Name = settings.Name
			ExperimentTemplate.Template = ChaosExperiment
			ExperimentTemplate.Engine = ChaosEngine

			tmp[ExperimentTemplate.Name] = ExperimentTemplate
		}
		hubSettings.Experiments = tmp
		HubChartServiceVersionTemplate, err := box.FindString("hub.chartserviceversion.tpl")
		if err != nil {
			log.Fatal(err)
		}
		HubPackageTemplate, err := box.FindString("hub.package.tpl")
		if err != nil {
			log.Fatal(err)
		}

		HubChartServiceVersion := ProcessTpl(HubChartServiceVersionTemplate, hubSettings)
		HubPackage := ProcessTpl(HubPackageTemplate, hubSettings)

		writeToFile(*buildPath+"/charts/"+hubs[hub].Name+"/"+hubs[hub].Name+".chartserviceversion.yaml", HubChartServiceVersion)
		writeToFile(*buildPath+"/charts/"+hubs[hub].Name+"/"+hubs[hub].Name+".package.yaml", HubPackage)

		os.MkdirAll(*buildPath+"/workflows/icons", os.ModePerm)
		for workflow := range hubs[hub].Workflows {
			os.MkdirAll(*buildPath+"/workflows/"+hubs[hub].Workflows[workflow].Name, os.ModePerm)

			WorkflowTemplate, err := box.FindString("workflow.tpl")
			if err != nil {
				log.Fatal(err)
			}

			WorkflowTemplateIcon, err := box.FindString("workflow.png")
			if err != nil {
				log.Fatal(err)
			}
			writeToFile(*buildPath+"/workflows/icons/"+hubs[hub].Workflows[workflow].Name+".png", WorkflowTemplateIcon)

			WorkflowChartServiceTemplate, err := box.FindString("workflow-chartserviceversion.tpl")
			if err != nil {
				log.Fatal(err)
			}

			var settings WorkflowSettings
			settings.Name = hubs[hub].Name
			settings.Experiments = hubSettings.Experiments
			settings.Workflow = hubs[hub].Workflows[workflow]

			ChaosWorkflow := ProcessTpl(WorkflowTemplate, settings)
			ChaosWorkflowChartServiceVersion := ProcessTpl(WorkflowChartServiceTemplate, settings)

			writeToFile(*buildPath+"/workflows/"+hubs[hub].Workflows[workflow].Name+"/"+hubs[hub].Workflows[workflow].Name+".chartserviceversion.yaml", ChaosWorkflowChartServiceVersion)
			writeToFile(*buildPath+"/workflows/"+hubs[hub].Workflows[workflow].Name+"/"+"workflow.yaml", ChaosWorkflow)

		}
		fmt.Print(hubs[hub].Name, " generated!!\n")
	}
	fmt.Print("Job done!\n\n")
}
