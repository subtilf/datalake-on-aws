# DataLake on AWS - Just for learn purpose!!!
<img src="https://github.com/subtilf/datalake-on-aws/blob/main/docs/images/datalake_macro.png?raw=true" width="500" height="500">


# What is a Datalake?
Acording to gartner "A data lake is a concept consisting of a collection of storage instances of various data assets. These assets are stored in a near-exact, or even exact, copy of the source format and are in addition to the originating data stores" - <a href="https://www.gartner.com/en/information-technology/glossary/data-lake">Reference</a>

Acording to Amazon "A data lake is a centralized repository that allows you to store all your structured and unstructured data at any scale. You can store your data as-is, without having to first structure the data, and run different types of analytics—from dashboards and visualizations to big data processing, real-time analytics, and machine learning to guide better decisions" - <a href="https://aws.amazon.com/pt/big-data/datalakes-and-analytics/what-is-a-data-lake/">Reference</a>

Acording to Databricks "A data lake is a central location, that holds a large amount of data in its native, raw format, as well as a way to organize large volumes of highly diverse data. Compared to a hierarchical data warehouse which stores data in files or folders, a data lake uses a different approach; it uses a flat architecture to store the data" - <a href="https://databricks.com/glossary/data-lake">Reference</a>

For me a data lake is a centralized repository well governed, it can store any kind of data (structured, semi-structured and non-structured), receive it in a batch/online way and can hold a huge amount of data. It can be used to create new concepts of information and be the source from BI systems (like a data warehouse) or advanced analytics systems.

# Motivation
When we start to think how structure the best datalake, many ideas start to comming to our mind, but some configuration and some implementations are not so clear from begging. That way I need to try some specific configuration and evaluate if it is good or no.

To analyse those configurations, I created this project. So, the objective of that repo is holding the constant evolution of data lake code, testing the datalake behavior using diferent configurations to achive the best datalake for my needs.

That way I decided to challenge myself to deploy my own version of datalake and try to use that on AWS.

If this project is not complete don't worry, it'll be soon!

# Solution Diagram
<img src="https://github.com/subtilf/datalake-on-aws/blob/main/docs/images/datalake_solution_diagram.png?raw=true" width="600" height="500">


# About the project
This project its divided in some folder. Please see below the objective of each one:
* docs - This folder is responsible to store all documentation and images;
* iam_policy_files - This folder is reponsible to store all iam policy files;
* modules - This folder is responsible to store all terraform's modules;
* named_folders - Some folders had the name of the item that will be implemented. Each folder has your own implementation and variables files;