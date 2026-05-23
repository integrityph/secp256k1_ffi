const testVectorsStr = """
[
  {
		"_name":"should correctly sha sample data",
		"tag":"616263",
    "msg":"68656c6c6f",
    "digest":"9fb62b89d5bc023749dd03fa1f77687de19087545a91ce454eb01c189c6b8e7b",
		"shouldPass":true
	},
  {
		"_name":"should correctly sha sample data",
		"tag":"",
    "msg":"",
    "digest":"2dba5dbc339e7316aea2683faf839c1b7b1ee2313db792112588118df066aa35",
		"shouldPass":true
	},
  {
		"_name":"should correctly sha sample data",
		"tag":"74616730",
    "msg":"",
    "digest":"c8f0420f495810ddb1644b4d00df426ef36d6bfee21398eb81d6492b2cb8f999",
		"shouldPass":true
	},
  {
		"_name":"should correctly sha sample data",
		"tag":"",
    "msg":"6d65737361676530",
    "digest":"311bd1ad43d00362c489b0ec9b9a3a67cf840967fc006b14617aede1cc2ed546",
		"shouldPass":true
	},
  {
		"_name":"should correctly sha sample data",
		"tag":"00000000",
    "msg":"0000000000000000000000000000000000000000000000000000000000000000",
    "digest":"99bc811054084d1d145a5e3109b7d4ed84f32e01c64c173373e4d0a7c9b4e9eb",
		"shouldPass":true
	},
  {
		"_name":"should correctly sha sample data",
		"tag":"5461704c656166",
    "msg":"d584ffc52a7d8e68cc664b51d78de4114c492b702a79e465825e17b48ca2e435",
    "digest":"1d2eeb303613353bd5eb00ad7a662464e4b00bd11e5e4c368bb17106cb500424",
		"shouldPass":true
	},
  {
		"_name":"should correctly sha sample data",
		"tag":"5461704c656166",
    "msg":"fb862dd72e16ad010cd99c6ab748b1a955fa14f3f4c340d25fe514bb949ae68d",
    "digest":"c4d94f86325b909d8481eca93c0afd3383e5f5253f2cbc1077b72da14dccf564",
		"shouldPass":true
	},
  {
		"_name":"should correctly sha sample data",
		"tag":"546170547765616b",
    "msg":"e6d9efbc2655a9a8f86492f87972122dbc0ed087b30769d4ea3390faede3e3b5",
    "digest":"992c1b0039aec507e795fac9940d65a0c1c614323fbe4a972b56d4420880a0d9",
		"shouldPass":true
	},
  {
		"_name":"should correctly sha sample data",
		"tag":"546170547765616b",
    "msg":"06ac6cc17e87005e88705113e069dd4c6acfcf46a8a4ee2586d0cdd743fc509c",
    "digest":"ea9bc52d35520d531be68b03f80dc4aac2ef0e22883b689835b02e40832edfbc",
		"shouldPass":true
	},
  {
		"_name":"should correctly sha sample data",
		"tag":"546170547765616b",
    "msg":"6dedd6e2dd7657cccc7aae3cd963467cb2300cd7e9225dfbc54cb6850c1a61b825c7a7fd2a2e76c8addfbd4610fed9c2ca8989457324533a4772c9fd4fb1ac71",
    "digest":"e6148bff15ceb58ad62bb4eb3dc7a410266698b6597c7e44abb8fd77b3f49fe0",
		"shouldPass":true
	}
]
""";