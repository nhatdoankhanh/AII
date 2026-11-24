CREATE CONSTRAINT IF NOT EXISTS FOR (n:DiabetesSource) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT IF NOT EXISTS FOR (n:DiabetesFact) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT IF NOT EXISTS FOR (n:DiabetesTopic) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT IF NOT EXISTS FOR (n:DiabetesConcept) REQUIRE n.name IS UNIQUE;

MERGE (s:DiabetesSource {id:'W01'}) SET s.title='Tổng quan và các thể đái tháo đường', s.owner='NIDDK', s.url='https://www.niddk.nih.gov/health-information/diabetes/overview/what-is-diabetes', s.format='HTML';

MERGE (s:DiabetesSource {id:'W02'}) SET s.title='Triệu chứng và nguyên nhân', s.owner='NIDDK', s.url='https://www.niddk.nih.gov/health-information/diabetes/overview/symptoms-causes', s.format='HTML';

MERGE (s:DiabetesSource {id:'W03'}) SET s.title='Xét nghiệm và xác định thể bệnh', s.owner='NIDDK', s.url='https://www.niddk.nih.gov/health-information/diabetes/overview/tests-diagnosis', s.format='HTML';

MERGE (s:DiabetesSource {id:'W04'}) SET s.title='Đái tháo đường típ 1', s.owner='NIDDK', s.url='https://www.niddk.nih.gov/health-information/diabetes/overview/what-is-diabetes/type-1-diabetes', s.format='HTML';

MERGE (s:DiabetesSource {id:'W05'}) SET s.title='Đái tháo đường típ 2', s.owner='NIDDK', s.url='https://www.niddk.nih.gov/health-information/diabetes/overview/what-is-diabetes/type-2-diabetes', s.format='HTML';

MERGE (s:DiabetesSource {id:'W06'}) SET s.title='Quản lý đái tháo đường thai kỳ', s.owner='NIDDK', s.url='https://www.niddk.nih.gov/health-information/diabetes/overview/what-is-diabetes/gestational/management-treatment', s.format='HTML';

MERGE (s:DiabetesSource {id:'W07'}) SET s.title='Lập kế hoạch bữa ăn', s.owner='CDC', s.url='https://www.cdc.gov/diabetes/healthy-eating/diabetes-meal-planning.html', s.format='HTML';

MERGE (s:DiabetesSource {id:'W08'}) SET s.title='Insulin, các nhóm thuốc và điều trị', s.owner='NIDDK', s.url='https://www.niddk.nih.gov/health-information/diabetes/overview/insulin-medicines-treatments', s.format='HTML';

MERGE (s:DiabetesSource {id:'W09'}) SET s.title='Biến chứng', s.owner='CDC', s.url='https://www.cdc.gov/diabetes/complications/index.html', s.format='HTML';

MERGE (s:DiabetesSource {id:'W10'}) SET s.title='Hạ đường huyết', s.owner='CDC', s.url='https://www.cdc.gov/diabetes/about/low-blood-sugar-hypoglycemia.html', s.format='HTML';

MERGE (s:DiabetesSource {id:'W11'}) SET s.title='Phòng ngừa đái tháo đường típ 2', s.owner='WHO Việt Nam', s.url='https://www.who.int/vietnam/vi/health-topics/diabetes', s.format='HTML';

MERGE (s:DiabetesSource {id:'W12'}) SET s.title='Chọn món khi ăn ngoài', s.owner='CDC', s.url='https://www.cdc.gov/diabetes/healthy-eating/eating-out.html', s.format='HTML';

MERGE (s:DiabetesSource {id:'W13'}) SET s.title='Vận động và theo dõi đường huyết', s.owner='CDC', s.url='https://www.cdc.gov/diabetes/living-with/physical-activity.html', s.format='HTML';

MERGE (s:DiabetesSource {id:'W14'}) SET s.title='Chăm sóc bàn chân', s.owner='CDC', s.url='https://www.cdc.gov/diabetes/diabetes-complications/diabetes-and-your-feet.html', s.format='HTML';

MERGE (s:DiabetesSource {id:'W15'}) SET s.title='Bảo vệ thị lực và khám mắt', s.owner='CDC', s.url='https://www.cdc.gov/diabetes/hcp/clinical-guidance/promote-eye-health.html', s.format='HTML';

MERGE (s:DiabetesSource {id:'W16'}) SET s.title='Bệnh thận do đái tháo đường', s.owner='NIDDK', s.url='https://www.niddk.nih.gov/health-information/diabetes/overview/preventing-problems/diabetic-kidney-disease', s.format='HTML';

MERGE (s:DiabetesSource {id:'W17'}) SET s.title='Công dụng và tác dụng phụ của metformin', s.owner='NHS', s.url='https://www.nhs.uk/medicines/metformin/', s.format='HTML';

MERGE (s:DiabetesSource {id:'W18'}) SET s.title='Hiểu về xét nghiệm HbA1c', s.owner='NIDDK', s.url='https://www.niddk.nih.gov/health-information/diagnostic-tests/a1c-test', s.format='HTML';

MERGE (s:DiabetesSource {id:'W19'}) SET s.title='T?ng quan, ch?n ?o?n, ?i?u tr? v? ph?ng ng?a ??i th?o ???ng', s.owner='WHO', s.url='https://www.who.int/news-room/fact-sheets/detail/diabetes', s.format='HTML';

MERGE (s:DiabetesSource {id:'W20'}) SET s.title='H?i ??p v? b?nh ??i th?o ???ng', s.owner='WHO', s.url='https://www.who.int/news-room/questions-and-answers/item/diabetes', s.format='HTML';

MERGE (s:DiabetesSource {id:'W21'}) SET s.title='Theo d?i v? qu?n l? ???ng huy?t', s.owner='CDC', s.url='https://www.cdc.gov/diabetes/treatment/', s.format='HTML';

MERGE (s:DiabetesSource {id:'P01'}) SET s.title='Hướng dẫn chẩn đoán và điều trị đái tháo đường típ 2 (2020)', s.owner='Bộ Y tế Việt Nam', s.url='https://www.benhvienhatrung.vn/wp-content/uploads/2022/06/5481-2020-HDDT-DTD-tip-2.pdf', s.format='PDF';

MERGE (s:DiabetesSource {id:'P02'}) SET s.title='4 Steps to Manage Your Diabetes for Life', s.owner='NIDDK', s.url='https://www.niddk.nih.gov/-/media/Files/Health-Information/Health-Professionals/Diabetes/health-care-professionals/4StepsToManageDiabetes-English_508.pdf', s.format='PDF';

MATCH (s:DiabetesSource {id:'W01'}) MERGE (t:DiabetesTopic {id:'overview'}) MERGE (c:DiabetesConcept {name:'Đái tháo đường'}) MERGE (f:DiabetesFact {id:'F01'}) SET f.text='Đái tháo đường xảy ra khi glucose trong máu tăng cao. Các thể thường gặp gồm típ 1, típ 2 và đái tháo đường thai kỳ.', f.section='What are the different types of diabetes?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W02'}) MERGE (t:DiabetesTopic {id:'symptom'}) MERGE (c:DiabetesConcept {name:'Triệu chứng'}) MERGE (f:DiabetesFact {id:'F02'}) SET f.text='Khát nhiều, tiểu nhiều, mệt, nhìn mờ hoặc vết thương lâu lành là những dấu hiệu có thể gặp. Một số người có rất ít triệu chứng.', f.section='What are the symptoms of diabetes?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W02'}) MERGE (t:DiabetesTopic {id:'symptom'}) MERGE (c:DiabetesConcept {name:'Típ 2'}) MERGE (f:DiabetesFact {id:'F03'}) SET f.text='Triệu chứng típ 2 có thể xuất hiện từ từ. Khi có triệu chứng hoặc yếu tố nguy cơ, hãy trao đổi với nhân viên y tế về xét nghiệm.', f.section='Type 2 diabetes symptoms' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W03'}) MERGE (t:DiabetesTopic {id:'test'}) MERGE (c:DiabetesConcept {name:'Xét nghiệm'}) MERGE (f:DiabetesFact {id:'F04'}) SET f.text='Bác sĩ có thể dùng HbA1c và xét nghiệm glucose máu để đánh giá đái tháo đường. Kết quả sàng lọc trên ứng dụng cần được đối chiếu với khám và xét nghiệm.', f.section='What tests are used to diagnose diabetes?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W03'}) MERGE (t:DiabetesTopic {id:'test'}) MERGE (c:DiabetesConcept {name:'Phân loại'}) MERGE (f:DiabetesFact {id:'F05'}) SET f.text='Chỉ số đường huyết đơn lẻ chưa đủ xác định típ bệnh. Trong một số trường hợp bác sĩ cần thêm tự kháng thể hoặc xét nghiệm di truyền.', f.section='Which tests help my doctor know what kind of diabetes I have?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W04'}) MERGE (t:DiabetesTopic {id:'overview'}) MERGE (c:DiabetesConcept {name:'Típ 1'}) MERGE (f:DiabetesFact {id:'F06'}) SET f.text='Ở típ 1, hệ miễn dịch tấn công các tế bào sản xuất insulin. Các triệu chứng có thể tiến triển nhanh.', f.section='What causes type 1 diabetes?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W05'}) MERGE (t:DiabetesTopic {id:'overview'}) MERGE (c:DiabetesConcept {name:'Típ 2'}) MERGE (f:DiabetesFact {id:'F07'}) SET f.text='Ở típ 2, cơ thể sử dụng insulin kém hiệu quả hoặc sản xuất chưa đủ insulin. Kế hoạch chăm sóc tùy vào tình trạng từng người.', f.section='What is type 2 diabetes?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W06'}) MERGE (t:DiabetesTopic {id:'pregnancy'}) MERGE (c:DiabetesConcept {name:'Thai kỳ'}) MERGE (f:DiabetesFact {id:'F08'}) SET f.text='Trong thai kỳ, kế hoạch ăn uống, vận động phù hợp và theo dõi đường huyết cần được thống nhất với đội ngũ sản khoa và điều trị.', f.section='Managing & Treating Gestational Diabetes' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W06'}) MERGE (t:DiabetesTopic {id:'pregnancy'}) MERGE (c:DiabetesConcept {name:'Điều trị thai kỳ'}) MERGE (f:DiabetesFact {id:'F09'}) SET f.text='Nếu thay đổi lối sống chưa đủ, bác sĩ có thể cân nhắc insulin. Hãy trao đổi với bác sĩ trước khi dùng thuốc trong thai kỳ.', f.section='How is gestational diabetes treated?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W07'}) MERGE (t:DiabetesTopic {id:'food'}) MERGE (c:DiabetesConcept {name:'Bữa ăn'}) MERGE (f:DiabetesFact {id:'F10'}) SET f.text='Có thể chia đĩa ăn thành nửa đĩa rau ít tinh bột, một phần tư đạm nạc và một phần tư thực phẩm chứa carbohydrate. Chọn nước lọc hoặc đồ uống không thêm đường.', f.section='The plate method' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W07'}) MERGE (t:DiabetesTopic {id:'food'}) MERGE (c:DiabetesConcept {name:'Thực phẩm cần hạn chế'}) MERGE (f:DiabetesFact {id:'F11'}) SET f.text='Ưu tiên thực phẩm ít chế biến. Hạn chế đường thêm vào và ngũ cốc tinh chế. Lượng carbohydrate và khẩu phần đều ảnh hưởng đến đường huyết.', f.section='Why a meal plan is important' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W08'}) MERGE (t:DiabetesTopic {id:'medicine'}) MERGE (c:DiabetesConcept {name:'Thuốc điều trị'}) MERGE (f:DiabetesFact {id:'F12'}) SET f.text='Các lựa chọn điều trị có thể gồm thuốc uống, thuốc tiêm và insulin. Bác sĩ cân nhắc típ bệnh, mức đường huyết, bệnh đi kèm và các thuốc đang dùng.', f.section='What medicines might I take for diabetes?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W08'}) MERGE (t:DiabetesTopic {id:'medicine'}) MERGE (c:DiabetesConcept {name:'Insulin'}) MERGE (f:DiabetesFact {id:'F13'}) SET f.text='Người mắc típ 1 cần insulin. Với típ 2, lựa chọn thuốc được điều chỉnh theo từng người. Hãy trao đổi với bác sĩ điều trị trước khi bắt đầu, đổi liều hoặc ngừng một thuốc.', f.section='Insulin, Medicines, & Other Diabetes Treatments' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W09'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Biến chứng'}) MERGE (f:DiabetesFact {id:'F14'}) SET f.text='Đái tháo đường có thể ảnh hưởng đến tim, thận, mắt và thần kinh. Khám định kỳ giúp phát hiện sớm các vấn đề để xử trí phù hợp.', f.section='Diabetes Complications' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W09'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Bàn chân'}) MERGE (f:DiabetesFact {id:'F15'}) SET f.text='Tổn thương thần kinh có thể liên quan đến các vấn đề ở bàn chân. Hãy trao đổi với nhân viên y tế về kiểm tra bàn chân và bảo vệ thị lực.', f.section='Your Feet and Diabetes' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W10'}) MERGE (t:DiabetesTopic {id:'low'}) MERGE (c:DiabetesConcept {name:'Hạ đường huyết'}) MERGE (f:DiabetesFact {id:'F16'}) SET f.text='Run, vã mồ hôi, đói hoặc lú lẫn có thể gặp khi đường huyết thấp. Người có nguy cơ nên thống nhất kế hoạch xử trí với nhân viên y tế.', f.section='Low Blood Sugar (Hypoglycemia)' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W10'}) MERGE (t:DiabetesTopic {id:'urgent'}) MERGE (c:DiabetesConcept {name:'Hạ đường huyết nặng'}) MERGE (f:DiabetesFact {id:'F17'}) SET f.text='Lú lẫn nặng, co giật hoặc mất ý thức có thể xảy ra khi hạ đường huyết nặng. Nếu đang xảy ra, hãy gọi cấp cứu ngay.', f.section='Severe low blood sugar' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'P01'}) MERGE (t:DiabetesTopic {id:'food'}) MERGE (c:DiabetesConcept {name:'Chất xơ'}) MERGE (f:DiabetesFact {id:'F18'}) SET f.text='Hướng dẫn của Bộ Y tế gợi ý rau, đậu và ngũ cốc nguyên hạt trong chế độ ăn. Có thể chọn trái cây nguyên miếng thay cho nước ép.', f.section='PDF tr. 31–33 · Phần 4, Dinh dưỡng' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'P01'}) MERGE (t:DiabetesTopic {id:'test'}) MERGE (c:DiabetesConcept {name:'Phân loại đái tháo đường'}) MERGE (f:DiabetesFact {id:'F19'}) SET f.text='Hướng dẫn của Bộ Y tế mô tả típ 1, típ 2, đái tháo đường thai kỳ và các thể đặc hiệu khác. Việc xác định thể bệnh cần đánh giá lâm sàng.', f.section='PDF tr. 13 · Phần 2, Phân loại đái tháo đường' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'P02'}) MERGE (t:DiabetesTopic {id:'care'}) MERGE (c:DiabetesConcept {name:'Theo dõi tại nhà'}) MERGE (f:DiabetesFact {id:'F20'}) SET f.text='Bạn có thể cùng bác sĩ lập kế hoạch chăm sóc, ghi lại kết quả theo dõi và chuẩn bị những câu hỏi cần trao đổi ở lần tái khám.', f.section='PDF tr. 10–12 · Step 3, Learn how to live with diabetes' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'P02'}) MERGE (t:DiabetesTopic {id:'care'}) MERGE (c:DiabetesConcept {name:'Tái khám'}) MERGE (f:DiabetesFact {id:'F21'}) SET f.text='Kế hoạch tự chăm sóc hằng ngày gồm lựa chọn bữa ăn phù hợp, vận động theo khả năng, dùng thuốc theo đơn và duy trì lịch khám.', f.section='PDF tr. 10–13 · Steps 3–4' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W11'}) MERGE (t:DiabetesTopic {id:'overview'}) MERGE (c:DiabetesConcept {name:'Phòng ngừa típ 2'}) MERGE (f:DiabetesFact {id:'F22'}) SET f.text='Vận động thường xuyên, duy trì cân nặng phù hợp và tránh thuốc lá có thể giúp ngăn ngừa hoặc trì hoãn đái tháo đường típ 2.', f.section='Bệnh đái tháo đường' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W12'}) MERGE (t:DiabetesTopic {id:'food'}) MERGE (c:DiabetesConcept {name:'Chọn món khi ăn ngoài'}) MERGE (f:DiabetesFact {id:'F23'}) SET f.text='Khi ăn ở quán, bạn có thể chọn món hấp hoặc nướng, gọi thêm rau và yêu cầu để nước sốt riêng. Nhờ vậy bạn tự điều chỉnh được lượng sốt dùng trong bữa.', f.section='Order wisely' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W12'}) MERGE (t:DiabetesTopic {id:'food'}) MERGE (c:DiabetesConcept {name:'Khẩu phần ở nhà hàng'}) MERGE (f:DiabetesFact {id:'F24'}) SET f.text='Nếu suất ăn ngoài quá lớn, bạn có thể chia món với người đi cùng hoặc để dành một phần cho bữa sau.', f.section='Share and savor' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W13'}) MERGE (t:DiabetesTopic {id:'care'}) MERGE (c:DiabetesConcept {name:'Bắt đầu đi bộ'}) MERGE (f:DiabetesFact {id:'F25'}) SET f.text='Nếu mới tập vận động, bạn có thể bắt đầu bằng một buổi đi bộ ngắn sau bữa tối rồi tăng dần theo khả năng. Hãy hỏi bác sĩ nếu chưa rõ hoạt động nào phù hợp với mình.', f.section='You can start slowly' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W13'}) MERGE (t:DiabetesTopic {id:'care'}) MERGE (c:DiabetesConcept {name:'Đường huyết và tập thể dục'}) MERGE (f:DiabetesFact {id:'F26'}) SET f.text='Đo đường huyết trước và sau khi đi bộ giúp bạn nhận biết cơ thể đáp ứng thế nào với vận động.', f.section='You can lower your blood sugar' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W14'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Kiểm tra bàn chân'}) MERGE (f:DiabetesFact {id:'F27'}) SET f.text='Kiểm tra bàn chân mỗi ngày, kể cả khi không đau. Tìm vết trầy, phồng rộp, sưng hoặc đỏ. Có thể dùng gương hoặc nhờ người thân nhìn giúp lòng bàn chân.', f.section='Tips for healthy feet' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W14'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Mất cảm giác ở bàn chân'}) MERGE (f:DiabetesFact {id:'F28'}) SET f.text='Tổn thương thần kinh có thể làm giảm cảm giác nóng, lạnh hoặc đau ở bàn chân. Vì thế vết thương nhỏ có thể bị bỏ sót.', f.section='Nerve damage' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W15'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Khám mắt và võng mạc'}) MERGE (f:DiabetesFact {id:'F29'}) SET f.text='Một số bệnh mắt do đái tháo đường diễn tiến khi thị lực chưa thay đổi rõ. Hãy hỏi bác sĩ mắt về lịch khám có giãn đồng tử để phát hiện tổn thương sớm.', f.section='Key messages to share with your patients' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W16'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Xét nghiệm thận'}) MERGE (f:DiabetesFact {id:'F30'}) SET f.text='Bệnh thận do đái tháo đường thường không gây triệu chứng sớm. Bác sĩ có thể xét nghiệm albumin trong nước tiểu và xét nghiệm máu để đánh giá khả năng lọc của thận.', f.section='How can I tell if I have diabetic kidney disease?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W16'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Huyết áp và thận'}) MERGE (f:DiabetesFact {id:'F31'}) SET f.text='Ở người mắc đái tháo đường, tăng huyết áp làm tăng nguy cơ bệnh thận. Hãy trao đổi về kiểm soát cả huyết áp và đường huyết khi theo dõi chức năng thận.', f.section='What increases my chances of developing diabetic kidney disease?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W17'}) MERGE (t:DiabetesTopic {id:'medicine'}) MERGE (c:DiabetesConcept {name:'Metformin dùng để làm gì'}) MERGE (f:DiabetesFact {id:'F32'}) SET f.text='Metformin là thuốc kê đơn giúp hạ đường huyết, có thể dùng trong điều trị đái tháo đường típ 2. Bác sĩ quyết định thuốc có phù hợp với từng người hay không.', f.section='What metformin is for' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W17'}) MERGE (t:DiabetesTopic {id:'medicine'}) MERGE (c:DiabetesConcept {name:'Tác dụng phụ của metformin'}) MERGE (f:DiabetesFact {id:'F33'}) SET f.text='Buồn nôn, tiêu chảy hoặc đau bụng có thể xảy ra khi dùng metformin. Nếu các triệu chứng gây khó chịu hoặc kéo dài, hãy trao đổi với bác sĩ hoặc dược sĩ.', f.section='Side effects of metformin' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W17'}) MERGE (t:DiabetesTopic {id:'medicine'}) MERGE (c:DiabetesConcept {name:'Quên liều metformin'}) MERGE (f:DiabetesFact {id:'F34'}) SET f.text='Nếu quên một liều metformin, không uống hai liều để bù. Kiểm tra hướng dẫn của đơn thuốc hoặc hỏi dược sĩ về lần uống tiếp theo.', f.section='If you miss a dose of metformin' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W18'}) MERGE (t:DiabetesTopic {id:'test'}) MERGE (c:DiabetesConcept {name:'HbA1c có cần nhịn ăn'}) MERGE (f:DiabetesFact {id:'F35'}) SET f.text='Riêng xét nghiệm HbA1c không đòi hỏi nhịn ăn. Nếu buổi lấy máu còn có xét nghiệm đường huyết lúc đói, hãy làm theo hướng dẫn chuẩn bị cho xét nghiệm đó.', f.section='How is the A1C test used to diagnose type 2 diabetes and prediabetes?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W18'}) MERGE (t:DiabetesTopic {id:'test'}) MERGE (c:DiabetesConcept {name:'Ý nghĩa HbA1c'}) MERGE (f:DiabetesFact {id:'F36'}) SET f.text='HbA1c phản ánh mức đường huyết trung bình trong khoảng ba tháng. Kết quả này giúp theo dõi xu hướng dài hạn, còn máy đo đường huyết ghi nhận giá trị tại thời điểm đo.', f.section='What is the A1C test?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W18'}) MERGE (t:DiabetesTopic {id:'pregnancy'}) MERGE (c:DiabetesConcept {name:'Xét nghiệm đái tháo đường thai kỳ'}) MERGE (f:DiabetesFact {id:'F37'}) SET f.text='Khi cần kiểm tra đái tháo đường thai kỳ, bác sĩ thường dùng xét nghiệm thử thách glucose hoặc nghiệm pháp dung nạp glucose vào khoảng tuần 24 đến 28 của thai kỳ.', f.section='Is the A1C test used during pregnancy?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W01'}) MERGE (t:DiabetesTopic {id:'overview'}) MERGE (c:DiabetesConcept {name:'Tiền tiểu đường'}) MERGE (f:DiabetesFact {id:'F38'}) SET f.text='Tiền tiểu đường là khi đường huyết cao hơn bình thường nhưng chưa đến mức chẩn đoán đái tháo đường típ 2. Người ở giai đoạn này có nguy cơ tiến triển lên típ 2.', f.section='Prediabetes' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W02'}) MERGE (t:DiabetesTopic {id:'overview'}) MERGE (c:DiabetesConcept {name:'Đái tháo đường đơn gen'}) MERGE (f:DiabetesFact {id:'F39'}) SET f.text='Một số thể hiếm do biến đổi ở một gen. Biến đổi có thể được di truyền hoặc xuất hiện lần đầu trong gia đình và thường làm tụy tạo ít insulin hơn.', f.section='Monogenic diabetes' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W03'}) MERGE (t:DiabetesTopic {id:'test'}) MERGE (c:DiabetesConcept {name:'Nhịn ăn trước xét nghiệm glucose lúc đói'}) MERGE (f:DiabetesFact {id:'F40'}) SET f.text='Để đo glucose huyết tương lúc đói, người được xét nghiệm thường lấy máu buổi sáng sau ít nhất 8 giờ nhịn ăn. Trong thời gian này chỉ uống nước lọc.', f.section='Fasting plasma glucose test' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W04'}) MERGE (t:DiabetesTopic {id:'test'}) MERGE (c:DiabetesConcept {name:'Tự kháng thể và LADA ở người lớn'}) MERGE (f:DiabetesFact {id:'F41'}) SET f.text='Ở một số người trưởng thành, quá trình tự miễn làm tổn thương tụy diễn ra chậm. Bác sĩ có thể dùng xét nghiệm tự kháng thể để đánh giá thể đái tháo đường tự miễn này.', f.section='Autoantibodies and latent autoimmune diabetes in adults' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W05'}) MERGE (t:DiabetesTopic {id:'overview'}) MERGE (c:DiabetesConcept {name:'Tiền sử gia đình và nguy cơ típ 2'}) MERGE (f:DiabetesFact {id:'F42'}) SET f.text='Người có người thân mắc đái tháo đường, ít vận động hoặc từng mắc đái tháo đường thai kỳ có nguy cơ mắc típ 2 cao hơn.', f.section='Who is more likely to develop type 2 diabetes?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W06'}) MERGE (t:DiabetesTopic {id:'pregnancy'}) MERGE (c:DiabetesConcept {name:'Ceton khi mang thai'}) MERGE (f:DiabetesFact {id:'F43'}) SET f.text='Trong thai kỳ, ăn không đủ hoặc có đường huyết quá cao có thể khiến cơ thể tạo ceton. Bác sĩ có thể hướng dẫn kiểm tra ceton trong máu hoặc nước tiểu.', f.section='Follow a healthy eating plan' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W07'}) MERGE (t:DiabetesTopic {id:'food'}) MERGE (c:DiabetesConcept {name:'Nước ép và trái cây nguyên quả'}) MERGE (f:DiabetesFact {id:'F44'}) SET f.text='Cùng là trái cây, nước ép thường làm đường huyết tăng nhanh hơn so với ăn quả nguyên. Khi ăn thực phẩm chứa carbohydrate cùng chất xơ, đạm hoặc chất béo, đường huyết có thể tăng chậm hơn.', f.section='Why a meal plan is important' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W08'}) MERGE (t:DiabetesTopic {id:'medicine'}) MERGE (c:DiabetesConcept {name:'Máy bơm insulin'}) MERGE (f:DiabetesFact {id:'F45'}) SET f.text='Máy bơm có thể đưa insulin dưới da liên tục. Một số loại dùng dây dẫn, một số gắn trực tiếp lên da. Thiết bị có thể được lập trình theo nhu cầu insulin.', f.section='Pump' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W09'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Thính lực và đái tháo đường'}) MERGE (f:DiabetesFact {id:'F46'}) SET f.text='CDC liệt kê giảm thính lực trong nhóm biến chứng cần lưu ý và khuyến khích người bệnh kiểm tra thính lực định kỳ.', f.section='Hearing Loss' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W10'}) MERGE (t:DiabetesTopic {id:'low'}) MERGE (c:DiabetesConcept {name:'Bỏ bữa và hạ đường huyết khi dùng insulin'}) MERGE (f:DiabetesFact {id:'F47'}) SET f.text='Ăn ít carbohydrate so với lượng insulin đang dùng có thể làm đường huyết hạ. Thời điểm dùng insulin và mức vận động cũng ảnh hưởng đến nguy cơ này.', f.section='Causes' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W10'}) MERGE (t:DiabetesTopic {id:'low'}) MERGE (c:DiabetesConcept {name:'Hạ đường huyết ban đêm'}) MERGE (f:DiabetesFact {id:'F48'}) SET f.text='Ăn đều bữa giúp giảm nguy cơ hạ đường huyết ban đêm. Người đang ngủ có thể không tự thức giấc khi đường huyết hạ. Máy theo dõi glucose liên tục có thể phát cảnh báo.', f.section='Nighttime low blood sugar' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W11'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Biến chứng mạch máu'}) MERGE (f:DiabetesFact {id:'F49'}) SET f.text='Đái tháo đường có thể gây tổn thương mạch máu và thần kinh. Các hậu quả nghiêm trọng có thể gồm nhồi máu cơ tim và đột quỵ.', f.section='Bệnh đái tháo đường ở Việt Nam' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W12'}) MERGE (t:DiabetesTopic {id:'food'}) MERGE (c:DiabetesConcept {name:'Chuẩn bị trước khi ăn ở nhà hàng'}) MERGE (f:DiabetesFact {id:'F50'}) SET f.text='Xem trước thực đơn để có thời gian chọn món. Nếu bữa ăn muộn hơn thường lệ, CDC gợi ý một bữa phụ nhỏ có chất xơ và đạm rồi điều chỉnh khẩu phần ở bữa chính.', f.section='Plan ahead' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W13'}) MERGE (t:DiabetesTopic {id:'care'}) MERGE (c:DiabetesConcept {name:'Vận động trong sinh hoạt hằng ngày'}) MERGE (f:DiabetesFact {id:'F51'}) SET f.text='Có thể tăng vận động bằng cách dùng cầu thang hoặc đứng dậy đi lại khi xem tivi. Chọn một mục tiêu cụ thể, vừa sức để dễ theo dõi tiến bộ.', f.section='Small changes can make a difference · Be specific' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W14'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Đi chân trần và chọn giày'}) MERGE (f:DiabetesFact {id:'F52'}) SET f.text='Để bảo vệ bàn chân, nên mang giày hoặc dép phù hợp ngay cả khi ở nhà. Kiểm tra bên trong giày để phát hiện sỏi, vật lạ hoặc lớp lót gồ ghề.', f.section='Tips for healthy feet' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W15'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Bảo vệ thị lực'}) MERGE (f:DiabetesFact {id:'F53'}) SET f.text='Khi trao đổi về bảo vệ mắt, CDC khuyến khích chú ý đến HbA1c, huyết áp, cholesterol, việc bỏ thuốc lá và lịch khám mắt định kỳ.', f.section='Help your patients see the connection between diabetes management and healthy vision' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W16'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Thói quen bảo vệ thận'}) MERGE (f:DiabetesFact {id:'F54'}) SET f.text='Bỏ thuốc lá, vận động phù hợp và ngủ đủ giấc là những thói quen hỗ trợ bảo vệ thận ở người mắc đái tháo đường.', f.section='Develop or maintain healthy lifestyle habits' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W17'}) MERGE (t:DiabetesTopic {id:'medicine'}) MERGE (c:DiabetesConcept {name:'Metformin và thực phẩm bổ sung'}) MERGE (f:DiabetesFact {id:'F55'}) SET f.text='Trước khi dùng metformin, nên cho bác sĩ hoặc dược sĩ biết các thuốc, vitamin, thảo dược và thực phẩm bổ sung đang dùng để họ xem xét tương tác.', f.section='Taking metformin with other medicines, food and drink' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W18'}) MERGE (t:DiabetesTopic {id:'test'}) MERGE (c:DiabetesConcept {name:'Thiếu sắt và độ tin cậy của HbA1c'}) MERGE (f:DiabetesFact {id:'F56'}) SET f.text='Thiếu sắt nặng có thể khiến HbA1c cao giả. Mất máu hoặc truyền máu gần đây cũng có thể làm kết quả thay đổi. Hãy báo các yếu tố này khi trao đổi về kết quả xét nghiệm.', f.section='A1C tests can be affected by changes in red blood cells or hemoglobin' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'P01'}) MERGE (t:DiabetesTopic {id:'complication'}) MERGE (c:DiabetesConcept {name:'Đánh giá nguy cơ loét bàn chân'}) MERGE (f:DiabetesFact {id:'F57'}) SET f.text='Bệnh thần kinh ngoại biên kèm biến dạng hoặc mất cảm giác ở chân là lý do để bác sĩ đánh giá nguy cơ loét bàn chân.', f.section='PDF tr. 37 · Mục 9, Chuyển tuyến' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'P02'}) MERGE (t:DiabetesTopic {id:'care'}) MERGE (c:DiabetesConcept {name:'Căng thẳng và đường huyết'}) MERGE (f:DiabetesFact {id:'F58'}) SET f.text='Căng thẳng có thể làm tăng đường huyết. Hít thở sâu, đi dạo hoặc nghe nhạc là một số cách giảm căng thẳng được tài liệu gợi ý.', f.section='PDF tr. 10 · Step 3, Cope with your diabetes' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'P02'}) MERGE (t:DiabetesTopic {id:'care'}) MERGE (c:DiabetesConcept {name:'Răng miệng và đái tháo đường'}) MERGE (f:DiabetesFact {id:'F59'}) SET f.text='Chải răng và làm sạch kẽ răng hằng ngày giúp chăm sóc răng và nướu. Khám nha khoa là một phần của kế hoạch chăm sóc định kỳ.', f.section='PDF tr. 12–13 · Steps 3–4' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W19'}) MERGE (t:DiabetesTopic {id:'overview'}) MERGE (c:DiabetesConcept {name:'??i th?o ???ng'}) MERGE (f:DiabetesFact {id:'ORG-01'}) SET f.text='??i th?o ???ng l? b?nh m?n t?nh x?y ra khi tuy?n t?y kh?ng s?n xu?t ?? insulin ho?c c? th? kh?ng s? d?ng insulin hi?u qu?. ???ng huy?t t?ng k?o d?i c? th? g?y t?n th??ng th?n kinh v? m?ch m?u.', f.section='T?ng quan' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W19'}) MERGE (t:DiabetesTopic {id:'overview'}) MERGE (c:DiabetesConcept {name:'Ph?ng ng?a t?p 2'}) MERGE (f:DiabetesFact {id:'ORG-02'}) SET f.text='Ho?t ??ng th? l?c th??ng xuy?n, ch? ?? ?n l?nh m?nh, duy tr? c?n n?ng ph? h?p v? tr?nh thu?c l? gi?p ph?ng ng?a ho?c tr? ho?n t?p 2.', f.section='Ph?ng ng?a' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W19'}) MERGE (t:DiabetesTopic {id:'test'}) MERGE (c:DiabetesConcept {name:'Ch?n ?o?n'}) MERGE (f:DiabetesFact {id:'ORG-03'}) SET f.text='Ph?t hi?n s?m ??i th?o ???ng c? th? th?c hi?n b?ng x?t nghi?m ???ng huy?t. Kh?m ??nh k? v? x?t nghi?m m?u gi?p ph?t hi?n t?p 2 s?m.', f.section='Ch?n ?o?n v? ?i?u tr?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W19'}) MERGE (t:DiabetesTopic {id:'care'}) MERGE (c:DiabetesConcept {name:'Theo d?i bi?n ch?ng'}) MERGE (f:DiabetesFact {id:'ORG-04'}) SET f.text='Ch?m s?c ??i th?o ???ng bao g?m s?ng l?c v? ?i?u tr? bi?n ch?ng nh? b?nh th?n, b?nh v?ng m?c v? lo?t b?n ch?n.', f.section='Ch?n ?o?n v? ?i?u tr?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W20'}) MERGE (t:DiabetesTopic {id:'symptom'}) MERGE (c:DiabetesConcept {name:'Tri?u ch?ng'}) MERGE (f:DiabetesFact {id:'ORG-05'}) SET f.text='Tri?u ch?ng th??ng g?p g?m kh?t nhi?u, ??i nhi?u, ti?u th??ng xuy?n, m?t m?i, nh?n m? v? s?t c?n kh?ng ch? ?. T?p 2 c? th? ti?n tri?n ?m th?m trong nhi?u n?m.', f.section='Tri?u ch?ng' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W20'}) MERGE (t:DiabetesTopic {id:'test'}) MERGE (c:DiabetesConcept {name:'X?t nghi?m ch?n ?o?n'}) MERGE (f:DiabetesFact {id:'ORG-06'}) SET f.text='C?c x?t nghi?m th??ng d?ng g?m glucose huy?t t??ng l?c ??i, nghi?m ph?p dung n?p glucose ???ng u?ng, HbA1c v? glucose huy?t t??ng b?t k? khi c? tri?u ch?ng t?ng ???ng huy?t ?i?n h?nh.', f.section='Ch?n ?o?n' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W20'}) MERGE (t:DiabetesTopic {id:'care'}) MERGE (c:DiabetesConcept {name:'?i?u tr? t?ng qu?t'}) MERGE (f:DiabetesFact {id:'ORG-07'}) SET f.text='Ch?m s?c th??ng g?m ?n u?ng l?nh m?nh, v?n ??ng th??ng xuy?n, theo d?i ???ng huy?t, thu?c ph? h?p v?i th? b?nh, h? tr? t? qu?n l? v? s?ng l?c bi?n ch?ng ??nh k?.', f.section='?i?u tr? v? qu?n l?' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W21'}) MERGE (t:DiabetesTopic {id:'care'}) MERGE (c:DiabetesConcept {name:'?o ???ng huy?t'}) MERGE (f:DiabetesFact {id:'ORG-08'}) SET f.text='C? th? theo d?i ???ng huy?t b?ng m?y ?o ???ng huy?t c? nh?n ho?c thi?t b? theo d?i glucose li?n t?c. Th?i ?i?m v? t?n su?t ?o ph? thu?c th? b?nh v? thu?c ?ang d?ng.', f.section='Theo d?i ???ng huy?t' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W21'}) MERGE (t:DiabetesTopic {id:'care'}) MERGE (c:DiabetesConcept {name:'M?c ti?u ???ng huy?t'}) MERGE (f:DiabetesFact {id:'ORG-09'}) SET f.text='M?c ti?u th??ng g?p v?i nhi?u ng??i tr??ng th?nh l? 80?130 mg/dL tr??c b?a ?n v? d??i 180 mg/dL hai gi? sau khi b?t ??u ?n. M?c ti?u c? nh?n c? th? kh?c, h?y trao ??i v?i nh?m ch?m s?c s?c kh?e.', f.section='M?c ti?u ???ng huy?t' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W21'}) MERGE (t:DiabetesTopic {id:'low'}) MERGE (c:DiabetesConcept {name:'H? ???ng huy?t'}) MERGE (f:DiabetesFact {id:'ORG-10'}) SET f.text='???ng huy?t d??i 70 mg/dL ???c xem l? th?p. B? b?a, d?ng qu? nhi?u insulin, m?t s? thu?c ?i?u tr?, v?n ??ng nhi?u h?n th??ng l? v? r??u c? th? g?p ph?n g?y h? ???ng huy?t.', f.section='M?c ti?u ???ng huy?t' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W21'}) MERGE (t:DiabetesTopic {id:'urgent'}) MERGE (c:DiabetesConcept {name:'T?ng ???ng huy?t v? nhi?m toan ceton'}) MERGE (f:DiabetesFact {id:'ORG-11'}) SET f.text='Khi ?ang b?nh v? ???ng huy?t t? 240 mg/dL tr? l?n, CDC khuy?n ki?m tra ceton b?ng b? th? ph? h?p. Ceton cao c? th? b?o hi?u nhi?m toan ceton do ??i th?o ???ng, m?t c?p c?u c?n ?i?u tr? ngay.', f.section='M?c ti?u ???ng huy?t' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);

MATCH (s:DiabetesSource {id:'W21'}) MERGE (t:DiabetesTopic {id:'food'}) MERGE (c:DiabetesConcept {name:'Th?i quen ?n u?ng'}) MERGE (f:DiabetesFact {id:'ORG-12'}) SET f.text='?n v?o th?i gian t??ng ??i ??u, kh?ng b? b?a, ch?n th?c ph?m ?t ???ng, mu?i, ch?t b?o b?o h?a v? u?ng n??c thay n??c ng?t c? th? h? tr? qu?n l? ???ng huy?t.', f.section='C?ch qu?n l? ???ng huy?t' MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s);
