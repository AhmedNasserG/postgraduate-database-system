# pg-database

# AUTH

Login credentials for testing purposes:
- GUCian Student
`email`: `GUCStudent@test.com`
`password`: `student`
- Non-GUCian Student
`email`: `NONGUCStudent@test.com`
`password`: `student`
- Supervisor
`email`: `supervisor@test.com`
`password`: `supervisor`
- Admin
`email`: `admin@test.com`
`password`: `admin`
- Examiner
`email`: `examiner@test.com`
`password`: `examiner`


## Project Structure 
 ```
 .
├── app.js   <- lanuch server
├── bin
├── database  
│   ├── db-design   <- data base design related files
│   │   ├── csv
│   │   ├── diagram
│   │   │   ├── final.drawio.pdf
│   │   │   └── final.drawio.xml
│   │   └── schema
│   │       ├── schema.pdf
│   │       └── schema.tex
│   └── scripts         <- sql proc and exce 
│       ├── data-insertion.sql
│       ├── execution.sql
│       ├── procedures.sql
│       ├── roles.sql
│       └── tables.sql
├── package.json
├── package-lock.json 
├── procedures    <- sql proc to js 
│   ├── examinerProcedures.js
│   ├── studentProcedures.js
│   ├── supervisorProcedures.js
│   └── userProcedures.js
├── public
│   ├── images
│   │   └── guc_logo.png 
│   └── stylesheets    -< css files 
│       ├── loginStyle.css
│       ├── student.css  
│       └── style.css
├── README.md
├── routes
│   ├── examiner.js
│   ├── login.js
│   ├── register.js
│   ├── student.js
│   └── supervisor.js
└── views                             <- html files (ejs)
    ├── examinerDashboard.ejs
    ├── login.ejs
    ├── register.ejs
    ├── studentDashboard.ejs
    └── supervisorDashboard.ejs
├── .env   <- env variables like port and db user and pass
├── .eslintrc.json <- linter config
```

## Design
- [Color scheme](https://colorhunt.co/palette/f0f5f9c9d6df52616b1e2022)
- [sidebar](https://codepen.io/jainharshit/pen/bGBRyLP)
- [icons](https://fontawesome.com/v5.15/icons?d=gallery&p=2&m=free)

